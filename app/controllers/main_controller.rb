class MainController < UIViewController
  # include MapKit
  def viewDidLoad
    super
    self.title = 'Next'
    @table = UITableView.alloc.initWithFrame(CGRectMake(0, 130, view.frame.size.width, view.frame.size.height - 130))
    @table.backgroundColor = UIColor.clearColor
    @table.dataSource = self
    @table.delegate = self

    @map_view = MKMapView.new
    @map_view.delegate = self
    @map_view.frame = self.view.frame
    # @map_view.shows_user_location = true
    # @map_view.zoom_enabled = true
    self.view.addSubview @map_view
    self.view.addSubview @table
    @cells = []
    @pins = {}
    load_data
  end

  # def mapView(map, didUpdateUserLocation:user_location)
  #   return unless has_user_coordinate?
  #   region = MKCoordinateRegionMakeWithDistance(user_coordinate,5000,5000)
  #   @map_view.region = region
  # end

  def user_coordinate
    @map_view.userLocation.location.coordinate
  end

  def has_user_coordinate?
    @map_view.userLocation.location
  end

  def scrollViewDidScroll(scrollView)
    scroll_offset = scrollView.contentOffset.y
    map_frame = @map_view.frame
    if scroll_offset < 0
      map_frame.origin.y = -130 - (scroll_offset / 3)
    else
      # @table.origin.y = @table.origin.y - scroll_offset
      # map_frame.origin.y = -100 - scroll_offset
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
    @map_view.removeAnnotation(@pins[cell.textLabel.text]) if cell
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: @reuseIdentifier)
    if !@cells.empty?
      item = @cells[indexPath.row][:item]
      @map_view.addAnnotation(item)
      @pins[@cells[indexPath.row][:title]] = item
      cell.backgroundColor = UIColor.cyanColor
      cell.textLabel.text = @cells[indexPath.row][:title]
      cell.detailTextLabel.text = @cells[indexPath.row][:description]
    end
    cell
  end

  def load_data(refreshing = false)
    FeedItem.find_all do |feed_items, response|
      if response.ok?
        region = MKCoordinateRegionMake(feed_items.first.coordinate, MKCoordinateSpanMake(0.5, 0.5))
        @map_view.setRegion(region)
        feed_items.map do |item|
          @cells << { item: item,
                      title: item.name,
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
