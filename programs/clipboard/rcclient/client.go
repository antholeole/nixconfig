package client

import (
	b64 "encoding/base64"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"

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
		if err != nil {
			return err
		}

		defer resp.Body.Close()
		bodyB64, err := io.ReadAll(resp.Body)

		if err != nil {
			return err
		}

		data, err := b64.StdEncoding.DecodeString(string(bodyB64))
		if err != nil {
			return err
		}

		fmt.Println(strings.TrimSuffix(string(data), "\n"))
	case "copy":
		stdin, err := io.ReadAll(os.Stdin)
		if err != nil {
			return err
		}

		suffixless := strings.TrimSuffix(string(stdin), "\n")
		reader := strings.NewReader(b64.StdEncoding.EncodeToString([]byte(suffixless)))

		_, err = http.Post(mkUrl(cmd), "text/plain", reader)

		if err != nil {
			return err
		}
	case "done":
		resp, err := http.Get(mkUrl(cmd))
		if err != nil {
			return err
		}

		defer resp.Body.Close()
	default:
		return fmt.Errorf("unknown command %s", cmd)
	}

	return nil
}
