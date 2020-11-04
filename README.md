# template_stream_deck_swift

Swift Stream Deck Project Template for MacOS

## Installation

```sh
git clone git@github.com:nicholascross/template_stream_deck_swift.git
```

Update `projgen.sh` so the `DEFAULT_PROJECTS_PATH` points to the location where you want the plugin project generated.

## How to use

```bash
./projgen.sh
```

This will download the DistributionTool available [here](https://developer.elgato.com/documentation/stream-deck/sdk/exporting-your-plugin/).

After entering a plugin name and bundle id a new plugin project will be generated under the `DEFAULT_PROJECTS_PATH` path.

`Plugin.swift` can then be modified to handle key presses and other events.

## Example

The linked [iOS simulator plugin](https://github.com/nicholascross/StreamDeckSimulator) was created using this template.

## Contribution

This project is still experimental and not fully utilised or tested by myself so I would encourage you to submit any fixes you make back here.
