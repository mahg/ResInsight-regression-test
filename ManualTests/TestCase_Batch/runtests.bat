@echo off
rem Absolute path to ResInsight.exe (first parameter)
set resinsight=%~dpnx1
rem Absolute path to project directory
set regtestdir=%~dp0
rem Move to project directory to execute
pushd %regtestdir%

@echo Running multiCaseSnapshots
%resinsight% --project %regtestdir%\RegressionTest.rsp --multiCaseSnapshots %regtestdir%\Caselist.txt --size 1024 800
@echo Running replaceCase
%resinsight% --project %regtestdir%\RegressionTest.rsp --replaceCase "../../ModelData/Case_with_10_timesteps/Real0/BRUGGE_0000.EGRID" --savesnapshots --size 1024 800
@echo Running replaceSourceCases
%resinsight% --project %regtestdir%\MultiCaseRegressionTest.rsp --replaceSourceCases %regtestdir%\MultiCaseList.txt --savesnapshots --size 1024 800

if [%2]==[] goto end

if exist %2 (
	@echo Running diffing
	if not exist "RegTestDiffImages" mkdir "RegTestDiffImages"
	if not exist "RegTestDiffImages/snapshots" mkdir "RegTestDiffImages/snapshots"
	if not exist "RegTestDiffImages/multiCaseSnapshots" mkdir "RegTestDiffImages/multiCaseSnapshots"
	pushd %2
	for %%i in (
		snapshots/Real0--BRUGGE_0000_EGRID_View_1_PERMZ_00_01-jan_1997.png
		snapshots/Statistics_1_View_1_PORO_RANGE_00_01-jan_1997.png
		multiCaseSnapshots/Real0--BRUGGE_0000_EGRID_View_1_PERMZ_00_01-jan_1997.png
		multiCaseSnapshots/Real10--BRUGGE_0010_EGRID_View_1_PERMZ_00_01-jan_1997.png
		multiCaseSnapshots/Real30--BRUGGE_0030_EGRID_View_1_PERMZ_00_01-jan_1997.png
		multiCaseSnapshots/Real40--BRUGGE_0040_EGRID_View_1_PERMZ_00_01-jan_1997.png
	) do (
		compare -fuzz 0.4%% -lowlight-color white -metric ae "%regtestdir%BaseImages/%%i" "%regtestdir%%%i" "%regtestdir%RegTestDiffImages/%%i"
	)
	popd
) else (
	@echo Could not find compare at %2
)

:end

rem Return to original executing directory
popd
