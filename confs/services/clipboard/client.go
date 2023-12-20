package main

import (
  "os"
  "strings"
  "io"
  "fmt"
  "log"
  "net/http"
  "oleinaconf.com/utils"
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

func mkUrl(path string) string {
	return fmt.Sprintf("http://localhost:%s/%s", utils.Port, path)
}

func run() error {
	switch cmd := os.Args[1]; cmd {
	case "paste": 
		resp, err := http.Get(mkUrl(cmd))
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

		_, err = http.Post(mkUrl(cmd), "text/plain", reader)

		if err != nil {
			return err
		}
	case "cliphist":
		resp, err := http.Get(mkUrl(cmd))
		defer resp.Body.Close()
		body, err := io.ReadAll(resp.Body)

		if err != nil {
			return err
		}

		fmt.Print(string(body))
	case "done": 	
		resp, err := http.Get(mkUrl(cmd))
		defer resp.Body.Close()

		if err != nil {
			return err
		}
	default: 
		return fmt.Errorf("unknown command %s", cmd)
	}

	return nil
}