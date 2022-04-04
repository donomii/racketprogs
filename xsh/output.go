package xsh

import (
	"fmt"
	"github.com/pterm/pterm"
	"log"
)

func drintf(formatStr string, args ...interface{}) {
	out := fmt.Sprintf(formatStr, args...)
	if WantDebug {
		if UsePterm {
			header := pterm.DefaultHeader.WithBackgroundStyle(pterm.NewStyle(pterm.BgLightMagenta))
			pterm.DefaultCenter.Println(header.Sprint(out))
		} else {
			log.Printf(formatStr, args...)
		}
	}
}

func drintln(args ...interface{}) {
	out := fmt.Sprintln(args...)
	if WantDebug {
		if UsePterm {
			header := pterm.DefaultHeader.WithBackgroundStyle(pterm.NewStyle(pterm.BgLightMagenta))
			pterm.DefaultCenter.Println(header.Sprint(out))
		} else {
			log.Println(args...)
		}
	}
}

func XshErr(formatStr string, args ...interface{}) {
	if WantErrors {
		out := fmt.Sprintf(formatStr, args...)
		if UsePterm {
			header := pterm.DefaultHeader.WithBackgroundStyle(pterm.NewStyle(pterm.BgRed))
			pterm.DefaultCenter.Println(header.Sprint(out))
		} else {
			fmt.Println("Err:", out)
		}
	}
}

func XshWarn(formatStr string, args ...interface{}) {
	if WantWarn {
		out := fmt.Sprintf(formatStr, args...)
		if UsePterm {
			header := pterm.DefaultHeader.WithBackgroundStyle(pterm.NewStyle(pterm.BgYellow))
			pterm.DefaultCenter.Println(header.Sprint(out))
		} else {
			fmt.Println("Warn:", out)
		}
	}
}

func XshInform(formatStr string, args ...interface{}) {
	if WantInform {
		out := fmt.Sprintf(formatStr, args...)
		if UsePterm {
			header := pterm.DefaultHeader.WithBackgroundStyle(pterm.NewStyle(pterm.BgBlue))
			pterm.DefaultCenter.Println(header.Sprint(out))
		} else {
			fmt.Println("Info:", out)
		}
	}
}

func XshTrace(formatStr string, args ...interface{}) {
	if WantTrace {
		out := fmt.Sprintf(formatStr, args...)
		if UsePterm {
			header := pterm.DefaultHeader.WithBackgroundStyle(pterm.NewStyle(pterm.BgGreen))
			pterm.DefaultCenter.Println(header.Sprint(out))
		} else {
			fmt.Println("Trace:", out)
		}
	}
}

func XshResponse(formatStr string, args ...interface{}) {
	out := fmt.Sprintf(formatStr, args...)
	if UsePterm {
		header := pterm.DefaultHeader.WithBackgroundStyle(pterm.NewStyle(pterm.BgBlue))
		pterm.Println(header.Sprint(out))
	} else {
		fmt.Println("xsh:", out)
	}
}
