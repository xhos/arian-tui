package app

import (
	"fmt"
)

func (m model) View() string {
	if m.err != nil {
		return m.err.Error()
	}

	str := fmt.Sprintf("\n\n   %s Loading forever... %s\n\n", m.spinner.View(), quitKeys.Help().Desc)
	if m.quitting {
		return str + "\n"
	}

	return str
}
