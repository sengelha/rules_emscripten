package main

import (
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

func link(args []string) error {
	if (os.Getenv("PATH") == "") {
		return fmt.Errorf("No PATH environment variable set")
	}

	flags := flag.NewFlagSet("EmccLink", flag.ExitOnError)
	emcc := flags.String("e", "", "The emcc executable")
	node := flags.String("n", "", "The node executable")
	output := flags.String("o", "", "The output object file")
	emConfig := flags.String("c", "", "The emscripten config file")
	configuration := flags.String("C", "", "The build configuration (opt, dbg, or fastbuild)")
	linkopts := flags.String("l", "", "Link options to pass to emcc")
	modularize := flags.Bool("m", false, "Whether to modularize the result")
	outputMemInit := flags.Bool("M", false, "Whether to output the memory init file")
	prejs := flags.String("p", "", "The file to use as a pre-js")
	postjs := flags.String("P", "", "The file to use as a post-js")
	extprejs := flags.String("x", "", "The file to use as an extern-pre-js")
	extpostjs := flags.String("X", "", "The file to use as an extern-post-js")
	wasm := flags.Bool("w", false, "Whether to output WASM")
	if err := flags.Parse(args); err != nil {
		return err
	}
	objFiles := flags.Args()

	if *emcc == "" {
		return fmt.Errorf("emcc binary not specified")
	}
	if (*node == "") {
		return fmt.Errorf("node binary not specified")
	}
	if *output == "" {
		return fmt.Errorf("output file not specified")
	}
	if *emConfig == "" {
		return fmt.Errorf("em_config file not specified")
	}
	if len(objFiles) == 0 {
		return fmt.Errorf("object files not specified")
	}

	emccAbsPath, err := filepath.Abs(*emcc)
	if err != nil {
		return err
	}
	emConfigAbsPath, err := filepath.Abs(*emConfig)
	if err != nil {
		return err
	}
	nodeAbsPath, err := filepath.Abs(*node)
	if err != nil {
		return err
	}

	environ := os.Environ()
	environ = append(environ, fmt.Sprintf("EM_CONFIG=%s", emConfigAbsPath))
	environ = append(environ, fmt.Sprintf("EM_NODE_JS=%s", nodeAbsPath))

	emccArgs := []string{"-o", *output}
	if *outputMemInit {
		emccArgs = append(emccArgs, "--memory-init-file", "1")
	} else {
		emccArgs = append(emccArgs, "--memory-init-file", "0")
	}
	if *modularize {
		emccArgs = append(emccArgs, "-s", "MODULARIZE=1")
	}
	if *configuration == "opt" {
		emccArgs = append(emccArgs, "-O3", "-DNDEBUG")
	} else {
		emccArgs = append(emccArgs, "-O0")
	}
	if *linkopts != "" {
		emccArgs = append(emccArgs, strings.Split(*linkopts, ";")...)
	}
	if *prejs != "" {
		emccArgs = append(emccArgs, "--pre-js", *prejs)
	}
	if *postjs != "" {
		emccArgs = append(emccArgs, "--post-js", *postjs)
	}
	if *extprejs != "" {
		emccArgs = append(emccArgs, "--extern-pre-js", *extprejs)
	}
	if *extpostjs != "" {
		emccArgs = append(emccArgs, "--extern-post-js", *extpostjs)
	}
	if !*wasm {
		emccArgs = append(emccArgs, "-s", "WASM=0")
	}
	emccArgs = append(emccArgs, objFiles...)
	cmd := exec.Command(emccAbsPath, emccArgs...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Env = environ
	if err := cmd.Run(); err != nil {
		return fmt.Errorf("error starting compiler: %v", err)
	}

	return nil
}
