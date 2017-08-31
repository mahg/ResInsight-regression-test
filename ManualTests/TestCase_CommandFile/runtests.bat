@echo off
rem Absolute path to ResInsight.exe (first parameter)
set resinsight=%~dpnx1
rem Absolute path to project directory
set regtestdir=%~dp0
rem Move to project directory to execute
pushd %regtestdir%

@echo Running test: Case looping
%resinsight% --commandFile %regtestdir%\LoopCommandFile.txt --commandFileProject %regtestdir%\RegressionTest.rsp --commandFileReplaceCases %regtestdir%\ReplaceCases.txt

if [%2]==[] goto end

if exist %2 (
	@echo Diffing images
	if not exist "RegTestDiffImages" mkdir "RegTestDiffImages"
	if not exist "RegTestDiffImages\LoopExports" mkdir "RegTestDiffImages\LoopExports"
	pushd %2
	for %%i in (
		LoopExports/Real0--Brugge_0000_EGRID_View_1_PERMZ_10_28-okt_1997.png
		LoopExports/Real0--Brugge_0000_EGRID_View_1_PRESSURE_05_31-mai_1997.png
		LoopExports/Real0--Brugge_0000_EGRID_View_1_PRESSURE_10_28-okt_1997.png
		LoopExports/Real10--Brugge_0010_EGRID_View_1_PERMZ_10_28-okt_1997.png
		LoopExports/Real10--Brugge_0010_EGRID_View_1_PRESSURE_05_31-mai_1997.png
		LoopExports/Real10--Brugge_0010_EGRID_View_1_PRESSURE_10_28-okt_1997.png
		LoopExports/Real30--Brugge_0030_EGRID_View_1_PERMZ_10_28-okt_1997.png
		LoopExports/Real30--Brugge_0030_EGRID_View_1_PRESSURE_05_31-mai_1997.png
		LoopExports/Real30--Brugge_0030_EGRID_View_1_PRESSURE_10_28-okt_1997.png
		LoopExports/Real40--Brugge_0040_EGRID_View_1_PERMZ_10_28-okt_1997.png
		LoopExports/Real40--Brugge_0040_EGRID_View_1_PRESSURE_05_31-mai_1997.png
		LoopExports/Real40--Brugge_0040_EGRID_View_1_PRESSURE_10_28-okt_1997.png
	) do (
		compare -fuzz 0.4%% -lowlight-color white -metric ae "%regtestdir%BaseImages/%%i" "%regtestdir%%%i" "%regtestdir%RegTestDiffImages/%%i"
	)
	popd
) else (
	@echo Could not find compare at %2
)

:end

rem Return to original directory
popd
