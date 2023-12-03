package main

import (
  "os"
  "strings"
  "io"
  "log"
  "net/http"
  "github.com/mkideal/cli"
  "oleinaconf.com/utils"
)

type argT struct {
  Wlcopy string `cli:"*wlcopy" usage:"path to wlcopy package to use"`
}

func main() {
	if len(os.Args) == 1 {
		log.Fatal("need args")
		return
	}

	os.Exit(cli.Run(new(argT), func(ctx *cli.Context) error {
		argv := ctx.Argv().(*argT)
    	run(argv)
    	return nil
	}))
	
}

func run(args *argT) error {
	switch cmd := os.Args[1]; cmd {
	case "paste": 
		resp, err := http.Get("http://localhost:9791/paste")
		defer resp.Body.Close()
		body, err := io.ReadAll(resp.Body)

		if err != nil {
			log.Fatal(err.Error)
			return nil
		}

		utils.Copy(string(body), args.Wlcopy)
	case "copy":
		if len(os.Args) < 2 {
			log.Fatal("what to copy?")
		}

		toCopy := os.Args[2]
		_, err := http.Post("http://localhost:9791/copy", "text/plain", strings.NewReader(toCopy))
		if err != nil {
			log.Fatal(err.Error)
			return nil
		}
	default: 
		log.Fatalf("unknown command %s", cmd)
	}

	return nil
}