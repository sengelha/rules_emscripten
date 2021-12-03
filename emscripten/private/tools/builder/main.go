package main

import (
	"log"
	"os"
)

func main() {
	log.SetPrefix("builder: ")

	verb, rest := os.Args[1], os.Args[2:]

	var action func(args []string) error
	switch verb {
	case "compile":
		action = compile
	case "link":
		action = link
	default:
		log.Fatalf("unknown action: %s", verb)
	}

	log.SetPrefix(verb + ": ")
	if err := action(rest); err != nil {
		log.Fatal(err)
	}
}