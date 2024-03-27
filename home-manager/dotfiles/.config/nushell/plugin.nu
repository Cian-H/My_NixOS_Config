register /home/cianh/.dotfiles/.config/nushell/plugins/nu_plugin_inc  {
  "sig": {
    "name": "inc",
    "usage": "Increment a value or version. Optionally use the column of a table.",
    "extra_usage": "",
    "search_terms": [],
    "required_positional": [],
    "optional_positional": [
      {
        "name": "cell_path",
        "desc": "cell path to update",
        "shape": "CellPath",
        "var_id": null,
        "default_value": null
      }
    ],
    "rest_positional": null,
    "named": [
      {
        "long": "help",
        "short": "h",
        "arg": null,
        "required": false,
        "desc": "Display the help message for this command",
        "var_id": null,
        "default_value": null
      },
      {
        "long": "major",
        "short": "M",
        "arg": null,
        "required": false,
        "desc": "increment the major version (eg 1.2.1 -> 2.0.0)",
        "var_id": null,
        "default_value": null
      },
      {
        "long": "minor",
        "short": "m",
        "arg": null,
        "required": false,
        "desc": "increment the minor version (eg 1.2.1 -> 1.3.0)",
        "var_id": null,
        "default_value": null
      },
      {
        "long": "patch",
        "short": "p",
        "arg": null,
        "required": false,
        "desc": "increment the patch version (eg 1.2.1 -> 1.2.2)",
        "var_id": null,
        "default_value": null
      }
    ],
    "input_output_types": [],
    "allow_variants_without_examples": false,
    "is_filter": false,
    "creates_scope": false,
    "allows_unknown_args": false,
    "category": "Default"
  },
  "examples": []
}

register /home/cianh/.dotfiles/.config/nushell/plugins/nu_plugin_audio_hook  {
  "sig": {
    "name": "sound",
    "usage": "a nushell plugin that can make noise, read audio file's metadata and play audio files",
    "extra_usage": "",
    "search_terms": [],
    "required_positional": [],
    "optional_positional": [],
    "rest_positional": null,
    "named": [
      {
        "long": "help",
        "short": "h",
        "arg": null,
        "required": false,
        "desc": "Display the help message for this command",
        "var_id": null,
        "default_value": null
      }
    ],
    "input_output_types": [],
    "allow_variants_without_examples": false,
    "is_filter": false,
    "creates_scope": false,
    "allows_unknown_args": false,
    "category": "Default"
  },
  "examples": [
    {
      "example": "sound make 1000 200ms",
      "description": "create a simple noise frequency",
      "result": null
    },
    {
      "example": "[ 300.0, 500.0,  1000.0, 400.0, 600.0 ] | each { |it| sound make $it 150ms }",
      "description": "create a simple noise sequence",
      "result": null
    },
    {
      "example": "sound play audio.mp4 -d 5min",
      "description": "play a sound and exits after 5min",
      "result": null
    },
    {
      "example": "sound meta audio.mp4 | sound play audio.mp3 -d $in.duration",
      "description": "play a sound for its duration",
      "result": null
    },
    {
      "example": "sound meta set audio.mp3 -k TPE1 -v new-artist",
      "description": "set artist of `audio.mp3` to `new-artist`",
      "result": null
    }
  ]
}

register /home/cianh/.dotfiles/.config/nushell/plugins/nu_plugin_audio_hook  {
  "sig": {
    "name": "sound beep",
    "usage": "play a beep sound",
    "extra_usage": "",
    "search_terms": [],
    "required_positional": [],
    "optional_positional": [],
    "rest_positional": null,
    "named": [
      {
        "long": "help",
        "short": "h",
        "arg": null,
        "required": false,
        "desc": "Display the help message for this command",
        "var_id": null,
        "default_value": null
      }
    ],
    "input_output_types": [],
    "allow_variants_without_examples": false,
    "is_filter": false,
    "creates_scope": false,
    "allows_unknown_args": false,
    "category": "Experimental"
  },
  "examples": []
}

register /home/cianh/.dotfiles/.config/nushell/plugins/nu_plugin_audio_hook  {
  "sig": {
    "name": "sound make",
    "usage": "creates a noise with given frequency and duration",
    "extra_usage": "",
    "search_terms": [],
    "required_positional": [
      {
        "name": "Frequency",
        "desc": "Frequency of the noise",
        "shape": "Float",
        "var_id": null,
        "default_value": null
      },
      {
        "name": "duration",
        "desc": "duration of the noise",
        "shape": "Duration",
        "var_id": null,
        "default_value": null
      }
    ],
    "optional_positional": [],
    "rest_positional": null,
    "named": [
      {
        "long": "help",
        "short": "h",
        "arg": null,
        "required": false,
        "desc": "Display the help message for this command",
        "var_id": null,
        "default_value": null
      },
      {
        "long": "amplify",
        "short": "a",
        "arg": "Float",
        "required": false,
        "desc": "amplify the sound by given value",
        "var_id": null,
        "default_value": null
      }
    ],
    "input_output_types": [],
    "allow_variants_without_examples": false,
    "is_filter": false,
    "creates_scope": false,
    "allows_unknown_args": false,
    "category": "Experimental"
  },
  "examples": [
    {
      "example": "sound make 1000 200ms",
      "description": "create a simple noise frequency",
      "result": null
    },
    {
      "example": "[ 300.0, 500.0,  1000.0, 400.0, 600.0 ] | each { |it| sound make $it 150ms }",
      "description": "create a simple noise sequence",
      "result": null
    }
  ]
}

register /home/cianh/.dotfiles/.config/nushell/plugins/nu_plugin_audio_hook  {
  "sig": {
    "name": "sound meta",
    "usage": "get duration and meta data of an audio file",
    "extra_usage": "",
    "search_terms": [],
    "required_positional": [
      {
        "name": "File Path",
        "desc": "file to play",
        "shape": "Filepath",
        "var_id": null,
        "default_value": null
      }
    ],
    "optional_positional": [],
    "rest_positional": null,
    "named": [
      {
        "long": "help",
        "short": "h",
        "arg": null,
        "required": false,
        "desc": "Display the help message for this command",
        "var_id": null,
        "default_value": null
      }
    ],
    "input_output_types": [],
    "allow_variants_without_examples": false,
    "is_filter": false,
    "creates_scope": false,
    "allows_unknown_args": false,
    "category": "Experimental"
  },
  "examples": []
}

register /home/cianh/.dotfiles/.config/nushell/plugins/nu_plugin_audio_hook  {
  "sig": {
    "name": "sound meta list",
    "usage": "list of all id3 frame",
    "extra_usage": "",
    "search_terms": [],
    "required_positional": [],
    "optional_positional": [],
    "rest_positional": null,
    "named": [
      {
        "long": "help",
        "short": "h",
        "arg": null,
        "required": false,
        "desc": "Display the help message for this command",
        "var_id": null,
        "default_value": null
      }
    ],
    "input_output_types": [],
    "allow_variants_without_examples": false,
    "is_filter": false,
    "creates_scope": false,
    "allows_unknown_args": false,
    "category": "Experimental"
  },
  "examples": []
}

register /home/cianh/.dotfiles/.config/nushell/plugins/nu_plugin_audio_hook  {
  "sig": {
    "name": "sound meta set",
    "usage": "set a id3 frame on an audio file",
    "extra_usage": "",
    "search_terms": [],
    "required_positional": [
      {
        "name": "File Path",
        "desc": "file to update",
        "shape": "Filepath",
        "var_id": null,
        "default_value": null
      }
    ],
    "optional_positional": [],
    "rest_positional": null,
    "named": [
      {
        "long": "help",
        "short": "h",
        "arg": null,
        "required": false,
        "desc": "Display the help message for this command",
        "var_id": null,
        "default_value": null
      },
      {
        "long": "key",
        "short": "k",
        "arg": "String",
        "required": true,
        "desc": "id3 key",
        "var_id": null,
        "default_value": null
      },
      {
        "long": "value",
        "short": "v",
        "arg": "String",
        "required": true,
        "desc": "id3 value",
        "var_id": null,
        "default_value": null
      }
    ],
    "input_output_types": [],
    "allow_variants_without_examples": false,
    "is_filter": false,
    "creates_scope": false,
    "allows_unknown_args": false,
    "category": "Experimental"
  },
  "examples": []
}

register /home/cianh/.dotfiles/.config/nushell/plugins/nu_plugin_audio_hook  {
  "sig": {
    "name": "sound play",
    "usage": "play an audio file, by default supports flac,Wav,mp3 and ogg files, install plugin with `all-decoders` feature to include aac and mp4(audio)",
    "extra_usage": "",
    "search_terms": [],
    "required_positional": [
      {
        "name": "File Path",
        "desc": "file to play",
        "shape": "Filepath",
        "var_id": null,
        "default_value": null
      }
    ],
    "optional_positional": [],
    "rest_positional": null,
    "named": [
      {
        "long": "help",
        "short": "h",
        "arg": null,
        "required": false,
        "desc": "Display the help message for this command",
        "var_id": null,
        "default_value": null
      },
      {
        "long": "duration",
        "short": "d",
        "arg": "Duration",
        "required": false,
        "desc": "duration of file (mandatory for non-wave formats like mp3) (default 1 hour)",
        "var_id": null,
        "default_value": null
      }
    ],
    "input_output_types": [],
    "allow_variants_without_examples": false,
    "is_filter": false,
    "creates_scope": false,
    "allows_unknown_args": false,
    "category": "Experimental"
  },
  "examples": [
    {
      "example": "sound play audio.mp4 -d 5min",
      "description": "play a sound and exits after 5min",
      "result": null
    },
    {
      "example": "sound meta audio.mp4 | sound play audio.mp3 -d $in.duration",
      "description": "play a sound for its duration",
      "result": null
    }
  ]
}

register /home/cianh/.dotfiles/.config/nushell/plugins/nu_plugin_units  {
  "sig": {
    "name": "units",
    "usage": "Convert between units",
    "extra_usage": "",
    "search_terms": [],
    "required_positional": [],
    "optional_positional": [],
    "rest_positional": null,
    "named": [
      {
        "long": "help",
        "short": "h",
        "arg": null,
        "required": false,
        "desc": "Display the help message for this command",
        "var_id": null,
        "default_value": null
      },
      {
        "long": "category",
        "short": "c",
        "arg": "String",
        "required": true,
        "desc": "specify the category",
        "var_id": null,
        "default_value": null
      },
      {
        "long": "unit",
        "short": "u",
        "arg": "String",
        "required": true,
        "desc": "specify the unit type",
        "var_id": null,
        "default_value": null
      },
      {
        "long": "value",
        "short": "v",
        "arg": "Float",
        "required": true,
        "desc": "specify the value",
        "var_id": null,
        "default_value": null
      }
    ],
    "input_output_types": [],
    "allow_variants_without_examples": false,
    "is_filter": false,
    "creates_scope": false,
    "allows_unknown_args": false,
    "category": "Generators"
  },
  "examples": []
}

