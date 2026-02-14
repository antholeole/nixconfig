package main

import (
	"encoding/base64"
	b64 "encoding/base64"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"os/exec"

	"github.com/gin-gonic/gin"
	"github.com/mkideal/cli"
	"oleinaconf.com/utils"
)

type argT struct {
	Wlcopy     string `cli:"*wlcopy" usage:"path to wlcopy package to use"`
	Wlpaste    string `cli:"*wlpaste" usage:"path to wlpaste package to use"`
	NotifySend string `cli:"*notify-send" usage:"path to notify-send package to use"`
}

func main() {
	os.Exit(cli.Run(new(argT), func(ctx *cli.Context) error {
		argv := ctx.Argv().(*argT)
		run(argv)
		return nil
	}))
}

func readBodyB64(c *gin.Context) (string, error) {
	toCopyB64, err := io.ReadAll(c.Request.Body)
	if err != nil {
		return "", err
	}

	return string(toCopyB64), nil
}

func run(args *argT) error {
	r := gin.Default()

	r.GET("/ping", func(c *gin.Context) {
		c.String(http.StatusOK, "pong")
	})

	r.POST("/copy", func(c *gin.Context) {
		body, err := readBodyB64(c)
		if err != nil {
			c.AbortWithError(http.StatusInternalServerError, err)
			log.Printf("Error reading request body: %v", err)
			return
		}

		err = utils.Copy(body, args.Wlcopy)
		if err != nil {
			c.AbortWithError(http.StatusInternalServerError, err)
			log.Printf("Error copying data: %v", err)
			return
		}

		c.Data(http.StatusOK, "text/plain", []byte("ok"))
	})

	r.GET("/paste", func(c *gin.Context) {
		cmd := exec.Command(args.Wlpaste)
		out, err := cmd.Output()

		if err != nil {
			c.AbortWithError(http.StatusInternalServerError, err)
			return
		}

		outBytes := []byte(out)
		out64String := b64.StdEncoding.EncodeToString(outBytes)
		out64Bytes := []byte(out64String)

		c.Data(http.StatusOK, "text/plain", out64Bytes)
	})

	r.POST("/notify", func(c *gin.Context) {
		bodyB64, err := readBodyB64(c)
		if err != nil {
			c.AbortWithError(http.StatusInternalServerError, err)
			return
		}

		body, err := base64.StdEncoding.DecodeString(bodyB64)
		if err != nil {
			c.AbortWithError(http.StatusInternalServerError, err)
			return
		}

		cmd := exec.Command(args.NotifySend, "notification from remote", string(body))
		out, err := cmd.Output()

		if err != nil {
			c.AbortWithError(http.StatusInternalServerError, err)
			return
		}

		c.Data(http.StatusOK, "text/plain", out)
	})

	return r.Run(fmt.Sprintf("localhost:%s", utils.Port))
}
