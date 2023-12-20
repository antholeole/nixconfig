package main

import (
	"fmt"
	"net/http"
	"os"
	"os/exec"

	"github.com/gin-gonic/gin"
	"github.com/mkideal/cli"
	"oleinaconf.com/utils"
)

type argT struct {
	Cliphist string `cli:"*cliphist" usage:"path to cliphist package to use"`
	Wlcopy   string `cli:"*wlcopy" usage:"path to wlcopy package to use"`
	Wlpaste  string `cli:"*wlpaste" usage:"path to wlpaste package to use"`
	NotifySend string `cli:"*notify-send" usage:"path to notify-send package to use"`
}

func main() {
	os.Exit(cli.Run(new(argT), func(ctx *cli.Context) error {
		argv := ctx.Argv().(*argT)
		run(argv)
		return nil
	}))
}

func run(args *argT) error {
	r := gin.Default()

	r.GET("/ping", func(c *gin.Context) {
		c.String(http.StatusOK, "pong")
	})

	r.GET("/cliphist", func(c *gin.Context) {
		cmd := exec.Command(args.Cliphist, "list")
		out, err := cmd.Output()

		if err != nil {
			c.AbortWithError(http.StatusInternalServerError, err)
			return
		}

		c.Data(http.StatusOK, "text/plain", out)
		return
	})

	r.POST("/copy", func(c *gin.Context) {
		toCopy, err := c.GetRawData()

		if err != nil {
			c.AbortWithError(http.StatusInternalServerError, err)
			return
		}

		err = utils.Copy(string(toCopy), args.Wlcopy)
		if err != nil {
			c.AbortWithError(http.StatusInternalServerError, err)
			return
		}
	})

	r.GET("/paste", func(c *gin.Context) {
		cmd := exec.Command(args.Wlpaste)
		out, err := cmd.Output()

		if err != nil {
			c.AbortWithError(http.StatusInternalServerError, err)
			return
		}

		c.Data(http.StatusOK, "text/plain", out)
		return
	})

	r.GET("/done", func(c *gin.Context) {
		cmd := exec.Command(args.Wlpaste)
		out, err := cmd.Output()

		if err != nil {
			c.AbortWithError(http.StatusInternalServerError, err)
			return
		}

		c.Data(http.StatusOK, "text/plain", out)
		return
	})

	return r.Run(fmt.Sprintf("localhost:%s", utils.Port))
}
