SetKeyDelay, 1000
CoordMode, Mouse, Client

get_tom_dsa()



get_tom_dsa(st := 0, en := 0){
	start_date := ""
	end_date := ""
	EnvAdd, start_date, %st%, Days 
	EnvAdd, end_date, %en%, Days 
	
	mess := st "___" start_date "____" en "________" end_date
	FormatTime, start_day, %start_date%, dd ; get single elements of start and end date 
	FormatTime, start_month, %start_date%, MM
	FormatTime, start_year, %start_date%, YYYY
	FormatTime, end_day, %end_date%, dd
	FormatTime, end_month, %end_date%, MM
	FormatTime, end_year, %end_date%, YYYY
	
	FormatTime, save_start_date, %start_date%, yyyy_MM_dd
	FormatTime, save_end_date, %end_date%, yyyy_MM_dd
	
	f_name := "H:\Abteilung Verwaltung\daily_dashboard\pdfs\" save_start_date ".pdf"
	
	
	if FileExist(f_name)
	{
		FileDelete, %f_name%
		
	}
	
	
	; MsgBox,,,test,1 ; unkown reason does not register key presses in termin planer
	SetKeyDelay, 1000
	WinActivate, Terminplan - Terminplanung
	WinMaximize, Terminplan - Terminplanung
	Sleep, 1500
	
	MouseClick, Left, 414, 25 ; clicks in termin planer to prepare for keystrokes
	
	MouseClick, l, 457, 68 ; pick dsa
	Sleep, 5000
	MouseClick, l, 1132, 121 ; click today
	Sleep, 5000
	Send, ^p
	Send, `n
	WinWait, Druckausgabe speichern unter
	Sleep, 300
	SetKeyDelay, 100
	Send, %f_name%
	SetKeyDelay, 1000
	Send, `n
	
}