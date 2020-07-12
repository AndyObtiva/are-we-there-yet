# TODO move to models 
java_import 'org.eclipse.nebula.widgets.ganttchart.ISettings'
java_import 'org.eclipse.nebula.widgets.ganttchart.AbstractSettings'

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
    
    def initialize
      super()
      default_settings = DefaultSettings.new
      SETTINGS_BOOLEAN.each do |setting|
        send(setting + '=', default_settings.send(setting))
      end
    end
  end
end
