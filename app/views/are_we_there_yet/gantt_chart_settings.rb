# TODO move to models 
java_import 'org.eclipse.nebula.widgets.ganttchart.ISettings'
java_import 'org.eclipse.nebula.widgets.ganttchart.AbstractSettings'
java_import 'org.eclipse.nebula.widgets.ganttchart.DefaultSettings'

class AreWeThereYet
  class GanttChartSettings < AbstractSettings
    SETTINGS_BOOLEAN = [
      "adjustForLetters",
      "allowArrowKeysToScrollChart",
      "allowBlankAreaDragAndDropToMoveDates",
      "allowBlankAreaVerticalDragAndDropToMoveChart",
      "allowCheckpointResizing",
      "allowHeaderSelection",
      "allowInfiniteHorizontalScrollBar",
      "allowPhaseOverlap",
      "allowScopeMenu",
      "alwaysDragAllEvents",
      "drawEventsDownToTheHourAndMinute",
      "drawEventString",
      "drawFillsToBottomWhenUsingGanttSections",
      "drawFullPercentageBar",
      "drawGanttSectionBarToBottom",
      "drawHeader",
      "drawHorizontalLines",
      "drawLockedDateMarks",
      "drawSectionBar",
      "drawSectionDetails",
      "drawSelectionMarkerAroundSelectedEvent",
      "drawVerticalLines",
      "enableAddEvent",
      "enableAutoScroll",
      "enableDragAndDrop",
      "enableLastDraw",
      "enableResizing",
      "enableZooming",
      "fireEmptyEventSelection",
      "flipBlankAreaDragDirection",
      "forceMouseWheelVerticalScroll",
      "getUseAdvancedTooltips",
      "lockHeaderOnVerticalScroll",
      "moveAndResizeOnlyDependentEventsThatAreLaterThanLinkedMoveEvent",
      "moveLinkedEventsWhenEventsAreMoved",
      "onVerticalDragDropShowInsertMarker",
      "printFooter",
      "printSelectedVerticallyComplete",
      "roundHourlyEventsOffToNearestHour",
      "scaleImageToDayWidth",
      "scrollChartVerticallyOnMouseWheel",
      "shiftHorizontalCenteredEventString",
      "showArrows",
      "showBarsIn3D",
      "showBoldScopeText",
      "showDateTips",
      "showDateTipsOnScrolling",
      "showDefaultMenuItemsOnEventRightClick",
      "showDeleteMenuOption",
      "showGradientEventBars",
      "showHolidayToolTips",
      "showMenuItemsOnRightClick",
      "showNumberOfDaysOnBars",
      "showOnlyDependenciesForSelectedItems",
      "showPlannedDates",
      "showPropertiesMenuOption",
      "showResizeDateTipOnBorders",
      "showSectionDetailMore",
      "showToolTips",
      "showZoomLevelBox",
      "startCalendarOnFirstDayOfWeek",
      "useSplitArrowConnections",
      "zoomToMousePointerDateOnWheelZooming"
    ]
    
    SETTINGS_BOOLEAN.each {|setting| attr_accessor setting}
    
    def initialize(current_settings = nil)
      super()
      if current_settings
        apply_settings(current_settings)
      else
        apply_settings(DefaultSettings.new)
        configure_app_initial_settings
      end      
    end
    
    def apply_settings(other_settings)
      SETTINGS_BOOLEAN.each do |setting|
        send(setting + '=', other_settings.send(setting))
      end
    end
    
    def configure_app_initial_settings
      self.drawVerticalLines = false
      self.allowBlankAreaDragAndDropToMoveDates = false
      self.allowInfiniteHorizontalScrollBar = false
      self.allowHeaderSelection = false
      self.drawFullPercentageBar = false
      self.drawSelectionMarkerAroundSelectedEvent = false
      self.enableDragAndDrop = false
      self.enableResizing = false
      self.enableZooming = false
      self.showDefaultMenuItemsOnEventRightClick = false
      self.showDeleteMenuOption = false
      self.showMenuItemsOnRightClick = false
      self.zoomToMousePointerDateOnWheelZooming = false
    end
  end
end
