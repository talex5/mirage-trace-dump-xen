To dump a trace from a Mirage unikernel running Xen domain `my-domain`:

```bash
mirage-trace-dump-xen my-domain out.ctf
```

The trace can then be viewed using [mirage-trace-viewer][].

Note: this code was extracted from mirage-trace-viewer to prevent it from being lost.
It has not been tested in its current form.

See [Visualising an Asynchronous Monad](http://roscidus.com/blog/blog/2014/10/27/visualising-an-asynchronous-monad/).

[mirage-trace-viewer]: https://github.com/talex5/mirage-trace-viewer
