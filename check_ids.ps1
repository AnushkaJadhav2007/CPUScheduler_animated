$html = [System.IO.File]::ReadAllText('index.html')
$ids = @(
    'lblHeaderClock', 'lblStatusText', 'lblGanttElapsed', 'lblProcessCount',
    'btnStart', 'btnPause', 'btnResume', 'btnStep', 'btnReset', 'btnAudioToggle',
    'sliderSpeed', 'lblSpeedVal', 'spinQuantum', 'processInputTbody',
    'txtPid', 'spinArrival', 'spinBurst', 'btnAddProcess', 'btnDeleteProcess', 'btnClearProcesses',
    'kpiAvgTat', 'kpiAvgWt', 'kpiCpuUtil', 'kpiStatus', 'kpiStatusSub', 'resultsTbody',
    'simulatorView', 'resultsPageView', 'btnViewTable', 'btnViewTableCard', 'btnBackToSim', 'btnReturnToRun',
    'resultsEmptyState', 'resultsContentWrap', 'resPageAvgTat', 'resPageAvgWt', 'resPageCpuUtil',
    'resPageTotalTime', 'resPageQuantumVal', 'resTableBadge', 'dedicatedResultsTbody',
    'highlightAvgTat', 'highlightAvgWt', 'highlightAvgTatCalc', 'highlightAvgWtCalc',
    'minionMascotWidget', 'minionTheorySlideout', 'btnCloseMinionTheory', 'btnDismissMinionTheory',
    'mascotSpeechBubble', 'mascotAvatarCircle', 'theorySlideoutTitle', 'theorySlideoutSubtitle',
    'theorySlideoutPara', 'theorySlideoutDetails', 'theorySlideoutMascot',
    'dashboardView', 'btnBackToDashboard', 'btnNavDashboard', 'btnNavQuiz', 'btnDashboardQuiz',
    'quantumRow', 'appTitle', 'appSubtitle', 'resPageTitle', 'resPageSubtitle', 'resTableTitle',
    'resPageFourthLabel', 'resPageFourthFormula', 'arenaCanvas', 'ganttCanvas'
)

$missing = 0
foreach ($id in $ids) {
    if (-not ($html.Contains("id=`"$id`"") -or $html.Contains("id='$id'"))) {
        Write-Host "MISSING: $id" -ForegroundColor Red
        $missing++
    }
}
Write-Host "Missing IDs: $missing"
