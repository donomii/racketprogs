package main

var cacheL map[string][]string

func CacheLines(key string, f func() []string) []string{
	if cacheL == nil {
		cacheL = map[string][]string{}
	}
	val, ok := cacheL[key]
	if !ok {
		cacheL[key] = f()
		val = CacheLines(key, f)
	}
	return val
}