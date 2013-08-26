class AlphabetController < UIViewController
  include MapKit
  def viewDidLoad
    super
    self.title = "Alphabet"
    @table = UITableView.alloc.initWithFrame(CGRectMake(0, 100, view.frame.size.width, view.frame.size.height - 100))
    @table.dataSource = self
    @table.backgroundColor = UIColor.clearColor
    @table.delegate = self

    @map_view = MapView.new
    @map_view.delegate = self
    @map_view.frame = self.view.frame
    @map_view.shows_user_location = true
    @map_view.zoom_enabled = true
    @map_view.region = CoordinateRegion.new([56, 10.6], [3.1, 3.1])
    self.view.addSubview @map_view
    self.view.addSubview @table
    @cells = []
    load_data
  end

  def scrollViewDidScroll(scrollView)
    scroll_offset = scrollView.contentOffset.y
    map_frame = @map_view.frame
    if scroll_offset < 0
      map_frame.origin.y = -100 - (scroll_offset / 3)
    else
      # @table.origin.y = @table.origin.y - scroll_offset
      map_frame.origin.y = -100 - scroll_offset
    end
    @map_view.frame = map_frame
  end

  def tableView(tableView, numberOfRowsInSection: section)
    return @cells.count
  end

  def tableView(tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
    cell.backgroundColor = UIColor.whiteColor;
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier)
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: @reuseIdentifier)

    if !@cells.empty?
      cell.backgroundColor = UIColor.cyanColor
      cell.textLabel.text = @cells[indexPath.row][:title]
      cell.detailTextLabel.text = @cells[indexPath.row][:description]
    end
    cell
  end

  def load_data(refreshing = false)
    FeedItem.find_all do |feed_items, response|
      if response.ok?
        feed_items.map do |item|
          @cells << { title: item.name,
                      description: item.description,
                     action: :show_details,
                     arguments: { id: item.id } }
        end
        @table.reloadData
      else
        App.alert response.error_message
      end
    end
  end
end
