require_relative 'custom_tool_tip_content_replacer'

# TODO move to models 
java_import 'org.eclipse.nebula.widgets.ganttchart.ISettings'
java_import 'org.eclipse.nebula.widgets.ganttchart.AbstractSettings'
java_import 'org.eclipse.nebula.widgets.ganttchart.DefaultSettings'

class AreWeThereYet
  class GanttChartSettings < DefaultSettings
    SETTINGS_BOOLEAN = [
      'drawVerticalLines', 
      'allowBlankAreaDragAndDropToMoveDates', 
      'allowInfiniteHorizontalScrollBar', 
      'allowHeaderSelection', 
      'drawFullPercentageBar', 
      'drawSelectionMarkerAroundSelectedEvent', 
      'enableDragAndDrop', 
      'enableResizing', 
      'enableZooming', 
      'showDateTips',
      'showDefaultMenuItemsOnEventRightClick', 
      'showDeleteMenuOption', 
      'showMenuItemsOnRightClick', 
      'zoomToMousePointerDateOnWheelZooming'
    ]
    
    # Turning settings to override into Ruby attributes
    SETTINGS_BOOLEAN.each {|setting| attr_accessor setting}
    
    def initialize
      super() # needed when subclassing a Java class
      configure_app_initial_settings
    end
    
    def getTextDisplayFormat
      "#name#"
    end
    
    def getDefaultAdvancedTooltipText
      "\\cePlanned: #sd# - #ed# (#days#)\n\\c100100100"
    end
    
    def getToolTipContentReplacer
      CustomToolTipContentReplacer.instance
    end
    
    def configure_app_initial_settings
      self.drawVerticalLines = false
      self.allowBlankAreaDragAndDropToMoveDates = false
      self.allowInfiniteHorizontalScrollBar = false
      self.allowHeaderSelection = false
      self.drawFullPercentageBar = false
      self.drawSelectionMarkerAroundSelectedEvent = true
      self.enableDragAndDrop = true
      self.enableResizing = true
      self.enableZooming = false
      self.showDateTips = true
      self.showDefaultMenuItemsOnEventRightClick = false
      self.showDeleteMenuOption = false
      self.showMenuItemsOnRightClick = false
      self.zoomToMousePointerDateOnWheelZooming = false
    end
  end
end
