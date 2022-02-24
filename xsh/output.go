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
	out := fmt.Sprintf("%+v,\n", args...)
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
	out := fmt.Sprintf(formatStr, args...)
	if UsePterm {
		header := pterm.DefaultHeader.WithBackgroundStyle(pterm.NewStyle(pterm.BgRed))
		pterm.DefaultCenter.Println(header.Sprint(out))
	}

}

func XshWarn(formatStr string, args ...interface{}) {
	out := fmt.Sprintf(formatStr, args...)
	if UsePterm {
		header := pterm.DefaultHeader.WithBackgroundStyle(pterm.NewStyle(pterm.BgYellow))
		pterm.DefaultCenter.Println(header.Sprint(out))
	}
}

func XshInform(formatStr string, args ...interface{}) {
	out := fmt.Sprintf(formatStr, args...)
	if UsePterm {
		header := pterm.DefaultHeader.WithBackgroundStyle(pterm.NewStyle(pterm.BgBlue))
		pterm.DefaultCenter.Println(header.Sprint(out))
	}
}

func XshTrace(formatStr string, args ...interface{}) {
	out := fmt.Sprintf(formatStr, args...)
	if UsePterm {
		header := pterm.DefaultHeader.WithBackgroundStyle(pterm.NewStyle(pterm.BgGreen))
		pterm.DefaultCenter.Println(header.Sprint(out))
	}
}
