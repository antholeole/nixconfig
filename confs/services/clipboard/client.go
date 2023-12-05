package main

import (
  "os"
  "strings"
  "io"
  "fmt"
  "log"
  "net/http"
)

func main() {
	if len(os.Args) == 1 {
		log.Fatal("need args")
		return
	}

	err := run()
	if err != nil {
		log.Fatal(err)
	}
}

func run() error {
	switch cmd := os.Args[1]; cmd {
	case "paste": 
		resp, err := http.Get("http://localhost:9791/paste")
		defer resp.Body.Close()
		body, err := io.ReadAll(resp.Body)

		if err != nil {
			return err
		}

		print(string(body))
	case "copy":
		stdin, err := io.ReadAll(os.Stdin)
		if err != nil {
			return err
		}

		suffixless := strings.TrimSuffix(string(stdin), "\n")
		reader := strings.NewReader(suffixless)

		_, err = http.Post("http://localhost:9791/copy", "text/plain", reader)

		if err != nil {
			return err
		}
	case "cliphist":
		resp, err := http.Get("http://localhost:9791/cliphist")
		defer resp.Body.Close()
		body, err := io.ReadAll(resp.Body)

		if err != nil {
			return err
		}

		print(string(body))
	default: 
		return fmt.Errorf("unknown command %s", cmd)
	}

	return nil
}