#=
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <https://unlicense.org>
=#

"""
    Resource(src::String, mime=mime_from_filename(src)[, html_attributes::Pair...])

A container for a URL-addressed resource that displays correctly in rich IDEs.

# Examples
```
Resource("https://julialang.org/assets/infra/logo.svg")
```

```
Resource("https://interactive-examples.mdn.mozilla.net/media/examples/flower.webm", :width => 100)
```

```
md\"\"\"
This is what a duck sounds like: \$(Resource("https://interactive-examples.mdn.mozilla.net/media/examples/t-rex-roar.mp3"))
md\"\"\"
```

"""
struct Resource
    src::AbstractString
    mime::Union{Nothing,MIME}
    html_attributes::NTuple{N,Pair} where N
end
Resource(src::AbstractString, html_attributes::Pair...) = Resource(src, mime_fromfilename(src), html_attributes)

function Base.show(io::IO, m::MIME"text/html", r::Resource)
    mime_str = string(r.mime)

    tag = if startswith(mime_str, "image/")
        :img
    elseif r.mime isa MIME"text/javascript"
        :script
    elseif startswith(mime_str, "audio/")
        :audio
    elseif startswith(mime_str, "video/")
        :video
    else
        :data
    end

    Base.show(io, m,
        @htl("""<$(tag) controls='' src=$(r.src) type=$(r.mime) $(Dict{String,Any}(
                string(k) => v
                for (k, v) in r.html_attributes
            ))></$(tag)>""")
    )
end


const RemoteResource = Resource

"""
Create a `Resource` for a local file (a base64 encoded data URL is generated).

# WARNING
`LocalResource` **will not work** when you share the script/notebook with someone else, _unless they have those resources at exactly the same location on their file system_.

## Recommended alternatives (images)
1. Go to [imgur.com](https://imgur.com) and drag&drop the image to the page. Right click on the image, and select "Copy image location". You can now use the image like so: `PlutoUI.Resource("https://i.imgur.com/SAzsMMA.jpg")`.
2. If your notebook is part of a git repository, place the image in the repository and use a relative path: `PlutoUI.LocalResource("../images/cat.jpg")`.

# Examples
```
LocalResource("./cat.jpg")
```

```
LocalResource("/home/fons/Videos/nijmegen.mp4", :width => 200)
```

```
md\"\"\"
This is what a duck sounds like: \$(LocalResource("../data/hannes.mp3"))
md\"\"\"
```
"""
function LocalResource(path::AbstractString, html_attributes::Pair...)
    # @warn """`LocalResource` **will not work** when you share the script/notebook with someone else, _unless they have those resources at exactly the same location on their file system_.

    # ## Recommended alternatives (images)
    # 1. Go to [imgur.com](https://imgur.com) and drag&drop the image to the page. Right click on the image, and select "Copy image location". You can now use the image like so: `PlutoUI.Resource("https://i.imgur.com/SAzsMMA.jpg")`.
    # 2. If your notebook is part of a git repository, place the image in the repository and use a relative path: `PlutoUI.LocalResource("../images/cat.jpg")`."""
    mime = mime_fromfilename(path)
    src = "data:$(
		    string(something(mime,""))
		);base64,$(
		    Base64.base64encode(read(path))
	    )"
    return Resource(src, mime, html_attributes)
	Resource(src, mime, html_attributes)
end


###
# MIMES
###

"Attempt to find the MIME pair corresponding to the extension of a filename. Defaults to `text/plain`."
function mime_fromfilename(filename; default::T=nothing, filename_maxlength=2000)::Union{MIME, T} where T
	if length(filename) > filename_maxlength
		default
    else
        MIMEs.mime_from_path(
            URIs.URI(filename).path,
            default
        )
	end
end