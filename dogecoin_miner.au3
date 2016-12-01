#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
;#include <MsgBoxConstants.au3>

#region ### START Koda GUI section ###
$doge_gui = GUICreate("dogedigger", 250, 430, 404, 354)
Opt("GUIOnEventMode", 1) ; Change to OnEvent mode
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")

$worker = GUICtrlCreateInput("Weblogin.Worker", 10, 40, 137, 26)
GUICtrlSetFont(-1, 10, 400, 0, "Comic Sans MS")
$Label1 = GUICtrlCreateLabel("dogedigger v0.3", 10, 10, 106, 22)
GUICtrlSetFont(-1, 10, 400, 0, "Comic Sans MS")
GUICtrlSetColor(-1, 0x00FF00)
$password = GUICtrlCreateInput("Worker Password", 10, 72, 137, 26, $ES_PASSWORD)
GUICtrlSetFont(-1, 10, 400, 0, "Comic Sans MS")

$start = GUICtrlCreateButton("such dig", 108, 392, 65, 25)
GUICtrlSetFont(-1, 10, 800, 0, "Comic Sans MS")
GUICtrlSetOnEvent($start, "start")

$stop = GUICtrlCreateButton("stahp!", 178, 392, 65, 25)
GUICtrlSetFont(-1, 10, 800, 0, "Comic Sans MS")
GUICtrlSetOnEvent($stop, "stop")

$info = GUICtrlCreateButton("donate", 8, 392, 65, 25)
GUICtrlSetFont(-1, 10, 400, 0, "Comic Sans MS")
GUICtrlSetOnEvent($info, "info")

$Group1 = GUICtrlCreateGroup("Options", 8, 104, 233, 249)
GUICtrlSetFont(-1, 10, 400, 0, "Comic Sans MS")

$pool_combo = GUICtrlCreateCombo("", 18, 208, 209, 25)
GUICtrlSetData(-1, "24/7 Mining,doge.247mining.com:3333|BallisticPool,pool.vim.ae:3334|Coinium EU,eu.coinium.org:3334|Coinium US,us.coinium.org:3334|CoinPool,eu.stratum.coinpool.de:1005|Coinspool,doge.coinspool.co:3333|CryptoMiner,doge.cryptominer.net:3402|CryptoPools,doge.cryptopools.com:3333|Cryptostew,doge.cryptostew.com:3333|CryptoValley,doge.cryptovalley.com:3333|Doge Pool,stratum1.doge-pool.com:3334|Doge PoolToBe,doge.pcfil.com:3333|Dogecoin Mining @ LiteMoons,doge.litemoons.com:9555|Dogecoin Pool,uk-1.dogecoinpool.com:3333|Dogehouse,stratum.dogehouse.org:3333|DogeChain,pool.dogechain.info:3333|DogeChina,www.dogechina.com:3333|DogeMining.net,stratum.dogemining.net:3333|Dogepool.net,dogepool.net:4444|Dogepool.pw,dogepool.pw:3333|Dogepool.ru,doge.bbpool.org:3334|DogePorn,pool.dogeporn.com:3333|Dude Pool,doge.dudethatsmypool.com:3333|Fast-Pool,fast-pool.com:3333|ForkPool,doge.forkpool.com:8372|Hash.so EU,pool-eu.hash.so:1337|Hash.so US,pool-us.hash.so:1337|HashDogs,hashdogs.org:3333|HashFaster,stratum-us.doge.hashfaster.com:3339|Mining4all,doge.mining4all.eu:3338|MooPool,moopool.com:4444|n0nplusultra,doge.n0nplusultra.net:4411|NonStopMine,nonstopmine.com:3353|Nut2Pools EU,dogeu.nut2pools.com:5585|Nut2Pools US,dogus.nut2pools.com:5585|Pool.pm,pickaxe.pool.pm:3301|Poolerino,doge.poolerino.com:3333|PoolGen,dogecoin.poolgen.com:3333|RapidHash,stratum.rapidhash.net:3333|SpeedMiner,speedminer.org:3333|Such Coins,de.suchcoins.com:3333|TeamDoge,teamdoge.com:3333|The Chunky Pool,pool.chunky.ms:3333|TurboShibe,turboshibe.us:3333", "Dogehouse,stratum.dogehouse.org:3333")
GUICtrlSetFont(-1, 10, 400, 0, "Comic Sans MS")

$gpu_label = GUICtrlCreateLabel("Graphics card", 18, 130, 89, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Comic Sans MS")

$gpu_combo = GUICtrlCreateCombo("", 18, 152, 209, 25, BitOR($CBS_DROPDOWN, $WS_VSCROLL))
GUICtrlSetData(-1, "default (intensity ignored)|Radeon 5750|Radeon 5770|Radeon 5850|Radeon 5870|Radeon 5970|Radeon 6750|Radeon 6770|Radeon 6850|Radeon 6870|Radeon 6930|Radeon 6950|Radeon 6970|Radeon 6990|Radeon 7750|Radeon 7770|Radeon 7850 (low usage)|Radeon 7850 (high usage)|Radeon 7870 (low usage)|Radeon 7870 (high usage)|Radeon 7950 (low usage)|Radeon 7950 (high usage)|Radeon 7970 (low usage)|Radeon 7970 (high usage)|Radeon R7 260|Radeon R7 260X|Radeon R9 270|Radeon R9 270X|Radeon R9 280|Radeon R9 280X|Radeon R9 290 (low usage)|Radeon R9 290 (high usage)|Radeon R9 290X (low usage)|Radeon R9 290X (high usage)|nVidia x86(gpu)|nVidia x86(gpu+cpu)|nVidia x64(gpu)|nVidia x64(gpu+cpu)", "default (intensity ignored)")
GUICtrlSetFont(-1, 10, 400, 0, "Comic Sans MS")
GUICtrlSetOnEvent($gpu_combo, "gpu_combo")

$standard = GUICtrlCreateRadio("Standard Pool", 18, 184, 113, 17)
GUICtrlSetFont(-1, 10, 400, 0, "Comic Sans MS")
GUICtrlSetOnEvent($standard, "standard")
GUICtrlSetState($standard, $GUI_CHECKED)
$selected = 1 ;for later checking

$p2p = GUICtrlCreateRadio("P2Pool", 18, 248, 113, 17)
GUICtrlSetFont(-1, 10, 400, 0, "Comic Sans MS")
GUICtrlSetOnEvent($p2p, "p2p")

$p2p_combo = GUICtrlCreateCombo("", 18, 268, 209, 26, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Altpool,doge.altpool.pw:19348|Big Crypto Pool,bigcryptopool.com:9555|BigIron,bigiron.homelinux.com:9555|Crypto49er (EU),doge-eu.crypto49er.com:9555|Crypto49er,doge.crypto49er.com:9555|Cyber and Knauf1,p2pool.name:9555|Doge Street,pool.doge.st:9555|Dogepool.tk,dogepool.tk:9555|DTDNS,doge.dtdns.net:9555|E-Pool,doge.e-pool.net:9555|FairUse,dogepool.fairuse.org:22550|Fast-Pool,fast-pool.com:9555|JungSource,doge.scryptpool.us|LiteMoons,pro.doge.litemoons.com:9555|LurkMore,doge.lurkmore.com:9555|P2nex,doge.p2nex.net:9555|PayBTC,pool.paybtc.pl:9555|Shitpost,pool.shitpost.asia:1917|Solidpool,solidpool.org:9555|Stargate,mining.stargate.si:9555|ToTheMoon,to-the-moon.info:9555|Woof,woof.co.in:9555", "Altpool,doge.altpool.pw:19348")
GUICtrlSetFont(-1, 10, 400, 0, "Comic Sans MS")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlSetState($p2p_combo, $GUI_DISABLE)

$Pic1 = GUICtrlCreatePic("doge.jpg", 160, 16, 81, 81)

$cpu_check = GUICtrlCreateCheckbox("CPU", 63, 364, 97, 17)
GUICtrlSetFont(-1, 10, 400, 0, "Comic Sans MS")

$gpu_check = GUICtrlCreateCheckbox("GPU", 8, 364, 49, 17)
GUICtrlSetFont(-1, 10, 400, 0, "Comic Sans MS")
GUICtrlSetState($gpu_check, $GUI_CHECKED)

$save = GUICtrlCreateButton("Save", 120, 312, 51, 25)
GUICtrlSetFont(-1, 10, 400, 0, "Comic Sans MS")
GUICtrlSetOnEvent($save, "save")

$load = GUICtrlCreateButton("Load", 178, 312, 48, 25)
GUICtrlSetFont(-1, 10, 400, 0, "Comic Sans MS")
GUICtrlSetOnEvent($load, "load")

$intensity_label = GUICtrlCreateLabel("Intensity", 16, 312, 59, 22)
GUICtrlSetFont(-1, 10, 400, 0, "Comic Sans MS")

$intensity = GUICtrlCreateInput("13", 80, 312, 25, 26)
GUICtrlSetFont(-1, 10, 400, 0, "Comic Sans MS")

GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

While 1
	$pool_input = StringRegExpReplace(GUICtrlRead($pool_combo), "(.*,)", "")
	$p2p_input = StringRegExpReplace(GUICtrlRead($p2p_combo), "(.*,)", "")
	$worker_input = GUICtrlRead($worker)
	$password_input = GUICtrlRead($password)
	$gpu_input = GUICtrlRead($gpu_combo)
	$intensity_input = GUICtrlRead($intensity)
WEnd

Func save()
	Local $file = FileOpen("settings.data", 2)
	FileWriteLine($file, $gpu_input)
	FileWriteLine($file, $worker_input)
	FileWriteLine($file, $password_input)
	FileWriteLine($file, GUICtrlRead($pool_combo))
	FileWriteLine($file, GUICtrlRead($p2p_combo))
	FileWriteLine($file, $intensity_input)

	FileWriteLine($file, GUICtrlRead($gpu_check))
	FileWriteLine($file, GUICtrlRead($cpu_check))

	FileWriteLine($file, GUICtrlRead($standard))
	FileWriteLine($file, GUICtrlRead($p2p))

	FileWriteLine($file, GUICtrlGetState($password))
	FileWriteLine($file, GUICtrlGetState($pool_combo))
	FileWriteLine($file, GUICtrlGetState($p2p_combo))

	FileClose($file)


EndFunc   ;==>save

Func load()
	Local $file = FileOpen("settings.data", 0)
	GUICtrlSetData($gpu_combo, FileReadLine($file, 1))
	GUICtrlSetData($worker, FileReadLine($file, 2))
	GUICtrlSetData($password, FileReadLine($file, 3))
	GUICtrlSetData($pool_combo, FileReadLine($file, 4))
	GUICtrlSetData($p2p_combo, FileReadLine($file, 5))
	GUICtrlSetData($intensity, FileReadLine($file, 6))

	GUICtrlSetState($gpu_check, FileReadLine($file, 7))
	GUICtrlSetState($cpu_check, FileReadLine($file, 8))

	GUICtrlSetState($standard, FileReadLine($file, 9))
	GUICtrlSetState($p2p, FileReadLine($file, 10))

	GUICtrlSetState($password, FileReadLine($file, 11))
	GUICtrlSetState($pool_combo, FileReadLine($file, 12))
	GUICtrlSetState($p2p_combo, FileReadLine($file, 13))

	FileClose($file)
EndFunc   ;==>load

Func standard()
	ConsoleWrite(@CRLF & "pressed standard")
	GUICtrlSetState($password, $GUI_ENABLE)
	GUICtrlSetState($pool_combo, $GUI_ENABLE)
	GUICtrlSetState($p2p_combo, $GUI_DISABLE)
	GUICtrlSetData($worker, "Weblogin.Worker")
	GUICtrlSetData($password, "Worker Password")
	$selected = 1
EndFunc   ;==>standard

Func gpu_combo()
	If $gpu_input = "nVidia x86(gpu)" Then
		GUICtrlSetData($intensity, "-")
	EndIf
	If $gpu_input = "nVidia x86(gpu+cpu)" Then
		GUICtrlSetData($intensity, "-")
	EndIf
	If $gpu_input = "nVidia x64(gpu)" Then
		GUICtrlSetData($intensity, "-")
	EndIf
	If $gpu_input = "nVidia x64(gpu+cpu)" Then
		GUICtrlSetData($intensity, "-")
	EndIf

	If $gpu_input = "Radeon 5750" Then
		GUICtrlSetData($intensity, "18")
	EndIf
	If $gpu_input = "Radeon 5770" Then
		GUICtrlSetData($intensity, "18")
	EndIf
	If $gpu_input = "Radeon 5850" Then
		GUICtrlSetData($intensity, "18")
	EndIf
	If $gpu_input = "Radeon 5870" Then
		GUICtrlSetData($intensity, "18")
	EndIf
	If $gpu_input = "Radeon 5970" Then
		GUICtrlSetData($intensity, "18")
	EndIf
	If $gpu_input = "Radeon 6750" Then
		GUICtrlSetData($intensity, "18")
	EndIf
	If $gpu_input = "Radeon 6770" Then
		GUICtrlSetData($intensity, "18")
	EndIf
	If $gpu_input = "Radeon 6850" Then
		GUICtrlSetData($intensity, "18")
	EndIf
	If $gpu_input = "Radeon 6870" Then
		GUICtrlSetData($intensity, "18")
	EndIf
	If $gpu_input = "Radeon 6930" Then
		GUICtrlSetData($intensity, "18")
	EndIf
	If $gpu_input = "Radeon 6950" Then
		GUICtrlSetData($intensity, "18")
	EndIf
	If $gpu_input = "Radeon 6970" Then
		GUICtrlSetData($intensity, "18")
	EndIf
	If $gpu_input = "Radeon 6990" Then
		GUICtrlSetData($intensity, "18")
	EndIf
	If $gpu_input = "Radeon 7750" Then
		GUICtrlSetData($intensity, "18")
	EndIf
	If $gpu_input = "Radeon 7770" Then
		GUICtrlSetData($intensity, "18")
	EndIf
	If $gpu_input = "Radeon 7850 (low usage)" Then
		GUICtrlSetData($intensity, "13")
	EndIf
	If $gpu_input = "Radeon 7850 (high usage)" Then
		GUICtrlSetData($intensity, "20")
	EndIf
	If $gpu_input = "Radeon 7870 (low usage)" Then
		GUICtrlSetData($intensity, "13")
	EndIf
	If $gpu_input = "Radeon 7870 (high usage)" Then
		GUICtrlSetData($intensity, "20")
	EndIf
	If $gpu_input = "Radeon 7950 (low usage)" Then
		GUICtrlSetData($intensity, "13")
	EndIf
	If $gpu_input = "Radeon 7950 (high usage)" Then
		GUICtrlSetData($intensity, "20")
	EndIf
	If $gpu_input = "Radeon 7970 (low usage)" Then
		GUICtrlSetData($intensity, "13")
	EndIf
	If $gpu_input = "Radeon 7970 (high usage)" Then
		GUICtrlSetData($intensity, "18")
	EndIf
	If $gpu_input = "Radeon R7 260" Then
		GUICtrlSetData($intensity, "18")
	EndIf
	If $gpu_input = "Radeon R7 260X" Then
		GUICtrlSetData($intensity, "18")
	EndIf
	If $gpu_input = "Radeon R9 270" Then
		GUICtrlSetData($intensity, "20")
	EndIf
	If $gpu_input = "Radeon R9 270X" Then
		GUICtrlSetData($intensity, "20")
	EndIf
	If $gpu_input = "Radeon R9 280" Then
		GUICtrlSetData($intensity, "20")
	EndIf
	If $gpu_input = "Radeon R9 280X" Then
		GUICtrlSetData($intensity, "13")
	EndIf
	If $gpu_input = "Radeon R9 290 (low usage)" Then
		GUICtrlSetData($intensity, "13")
	EndIf
	If $gpu_input = "Radeon R9 290 (high usage)" Then
		GUICtrlSetData($intensity, "13")
	EndIf
	If $gpu_input = "Radeon R9 290X (low usage)" Then
		GUICtrlSetData($intensity, "13")
	EndIf
	If $gpu_input = "Radeon R9 290X (high usage)" Then
		GUICtrlSetData($intensity, "20")
	EndIf

EndFunc   ;==>gpu_combo

Func p2p()
	ConsoleWrite(@CRLF & "pressed p2p")
	GUICtrlSetState($password, $GUI_DISABLE)
	GUICtrlSetState($pool_combo, $GUI_DISABLE)
	GUICtrlSetState($p2p_combo, $GUI_ENABLE)
	GUICtrlSetData($worker, "Address")
	GUICtrlSetData($password, "")
	$selected = 0
	;todo save what was selected for later use
EndFunc   ;==>p2p

Func info()
	ClipPut("D7uzDhr25q66pNGBwDuBmQrG5mQsZSzbrB")
	MsgBox(0, "DOGEdigger", "much support: D7uzDhr25q66pNGBwDuBmQrG5mQsZSzbrB " & @CRLF & "copied to clipboard")
EndFunc   ;==>info

Func start()
	;ConsoleWrite(@CRLF&"pool input:"&$pool_input)

	If $selected = 0 Then
		ConsoleWrite(@CRLF & "using p2p")
		$pool_input = ""
	Else
		ConsoleWrite(@CRLF & "using standard")
		$p2p_input = ""
	EndIf ;flushes the non-used combo box so that both can be used for cgminer command line

	ProcessClose("cgminer.exe")
	ProcessClose("cudaminer.exe")
	ProcessClose("minerd.exe")
	FileDelete("scrypt*.bin")

	If GUICtrlRead($gpu_check) = 1 Then

		If $gpu_input = "default (intensity ignored)" Then
			;ConsoleWrite(@CRLF&"cgminer.exe --scrypt -o stratum+tcp://"&$pool_input&$p2p_input&" -u "&$worker_input&" -p "&$password_input)
			ShellExecute("cgminer.exe", "--scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		;radeon section start
		If $gpu_input = "Radeon 5750" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 3200 -w 256 -g 1 -I 18 --shaders 720 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon 5770" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 3200 -w 256 -g 1 -I 18 --shaders 800 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon 5850" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 6144 -w 256 -g 1 -I 18 --shaders 1440 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon 5870" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 6144 -w 256 -g 1 -I 18 --shaders 1600 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon 5970" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 6144 -w 256 -g 1 -I 18 --shaders 3200 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon 6750" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 3200 -w 256 -g 1 -I 18 --shaders 720 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon 6770" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 3200 -w 256 -g 1 -I 18 --shaders 800 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon 6850" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 6144 -w 256 -g 1 -I 18 --shaders 960 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon 6870" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 6720 -w 256 -g 1 -I 18 --shaders 1120 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon 6930" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 8000 -w 256 -g 1 -I 18 --shaders 1280 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon 6950" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 8000 -w 256 -g 1 -I 18 --shaders 1408 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon 6970" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 8000 -w 256 -g 1 -I 18 --shaders 1536 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon 6990" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 8000 -w 256 -g 1 -I 18 --shaders 3072 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon 7750" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 7168 -w 256 -g 1 -I 18 --shaders 512 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon 7770" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 8000 -w 256 -g 1 -I 18 --shaders 640 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon 7850 (low usage)" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 8192 -w 256 -g 2 -I 13 --shaders 1024 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon 7850 (high usage)" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 12404 -w 256 -g 1 -I 20 --shaders 1024 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon 7870 (low usage)" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 8192 -w 256 -g 2 -I 13 --shaders 1280 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon 7870 (high usage)" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 15508 -w 256 -g 1 -I 20 --shaders 1280 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon 7950 (low usage)" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 8192 -w 256 -g 2 -I 13 --shaders 1792 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon 7950 (high usage)" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 21712 -w 256 -g 1 -I 20 --shaders 1792 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon 7970 (low usage)" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 8192 -w 256 -g 2 -I 13 --shaders 2048 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon 7970 (high usage)" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 14336 -w 256 -g 2 -I 18 --shaders 2048 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon R7 260" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 8000 -w 256 -g 1 -I 18 --shaders 768 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon R7 260X" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 8000 -w 256 -g 1 -I 18 --shaders 896 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon R9 270" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 21568 -w 256 -g 1 -I 20 --shaders 1280 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon R9 270X" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 21568 -w 256 -g 1 -I 20 --shaders 1280 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon R9 280" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 21712 -w 256 -g 1 -I 20 --shaders 2048 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon R9 280X" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 8192 -w 256 -g 2 -I 13 --gpu-powertune 20 --shaders 2048 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon R9 290 (low usage)" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 10240 -w 256 -g 2 -I 13 --shaders 2560 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon R9 290 (high usage)" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 11264 -w 256 -g 2 -I 13 --shaders 2816 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon R9 290X (low usage)" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 11264 -w 256 -g 2 -I 13  --gpu-powertune 20 --shaders 2816 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		If $gpu_input = "Radeon R9 290X (high usage)" Then
			ShellExecute("cgminer.exe", "-I " & $intensity_input & " --thread-concurrency 32765 -w 256 -g 1 -I 20 --gpu-powertune 20 --shaders 2816 --scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -u " & $worker_input & " -p " & $password_input)
		EndIf
		;radeon section end
		If $gpu_input = "nVidia x86(gpu)" Then
			;ConsoleWrite(@CRLF&"cudaminer.exe -H 2 -i 0 -l auto -C 1 -o stratum+tcp://"&$pool_input&$p2p_input&" -O "&$worker_input&":"&$password_input,@ScriptDir&"\cuda\x86\")
			ShellExecute("cudaminer.exe", "-H 2 -i 0 -l auto -C 1 -o stratum+tcp://" & $pool_input & $p2p_input & " -O " & $worker_input & ":" & $password_input, @ScriptDir & "\cuda\x86\")
		EndIf

		If $gpu_input = "nVidia x86(gpu+cpu)" Then
			ShellExecute("cudaminer.exe", "-H 1 -i 0 -l auto -C 1 -o stratum+tcp://" & $pool_input & $p2p_input & " -O " & $worker_input & ":" & $password_input, @ScriptDir & "\cuda\x86\")
		EndIf

		If $gpu_input = "nVidia x64(gpu)" Then
			;ConsoleWrite(@CRLF&"cudaminer.exe -H 2 -i 0 -l auto -C 1 -o stratum+tcp://"&$pool_input&$p2p_input&" -O "&$worker_input&":"&$password_input,@ScriptDir&"\cuda\x64\")
			ShellExecute("cudaminer.exe", "-H 2 -i 0 -l auto -C 1 -o stratum+tcp://" & $pool_input & $p2p_input & " -O " & $worker_input & ":" & $password_input, @ScriptDir & "\cuda\x64\")
		EndIf

		If $gpu_input = "nVidia x64(gpu+cpu)" Then
			ShellExecute("cudaminer.exe", "-H 1 -i 0 -l auto -C 1 -o stratum+tcp://" & $pool_input & $p2p_input & " -O " & $worker_input & ":" & $password_input, @ScriptDir & "\cuda\x64\")
		EndIf
	EndIf

	If GUICtrlRead($cpu_check) = $GUI_CHECKED Then
		ShellExecute("minerd.exe", "-a scrypt -o stratum+tcp://" & $pool_input & $p2p_input & " -O " & $worker_input & ":" & $password_input, @ScriptDir & "\cpu")
	EndIf

EndFunc   ;==>start

Func stop()
	ProcessClose("cgminer.exe")
	ProcessClose("cudaminer.exe")
	ProcessClose("minerd.exe")
EndFunc   ;==>stop

Func CLOSEClicked()
	Exit
EndFunc   ;==>CLOSEClicked
