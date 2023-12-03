package main

import (
  "net/http"
  "fmt"
  "os"
  "os/exec"
  "github.com/gin-gonic/gin"
  "github.com/mkideal/cli"
)


type argT struct {
  Cliphist string `cli:"cliphist" usage:"path to cliphist package to use"`
  Wlcopy string `cli:"wlcopy" usage:"path to wlcopy package to use"`
  Wlpaste string `cli:"wlpaste" usage:"path to wlpaste package to use"`
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

    cmd := exec.Command("/bin/bash", "-c", fmt.Sprintf("echo \"%s\" | %s > /dev/null 2>&1 &", toCopy, args.Wlcopy))
    _, err = cmd.Output()
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

  return r.Run("localhost:9791")
}
