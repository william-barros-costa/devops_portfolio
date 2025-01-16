// Sample Test to show on pipeline

package main

import "testing"

func DummyTest(t *testing.T) {
	t.Run("Dummy test function", func(t *testing.T) {
		if 1+1 != 2 {
			t.Error("Mathematics is failing")
		}
	})
}
