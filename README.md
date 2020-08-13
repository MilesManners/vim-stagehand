# stagehand.vim

Press `s` to take your current visual selection backstage.

Once you have it backstage, make as many edits as you want. When you save backstage, all your changes will come back to the original buffer like you had never left it.

For the real galaxy brain users out there, try combining stagehand with
[goyo.vim](https://github.com/junegunn/goyo.vim) and [limelight.vim](https://github.com/junegunn/limelight.vim). Stagehand provides events for this purpose.

```vim
autocmd! User StagehandEnter Goyo
autocmd! User StagehandLeave Goyo!
```

## Installation

This plugin follows the standard runtime path structure, and as such it can be installed with a variety of plugin managers:

| Plugin Manager | Install with... |
| ------------- | ------------- |
| [Pathogen][11] | `git clone https://github.com/milesmanners/vim-stagehand ~/.vim/bundle/vim-stagehand`<br/>Remember to run `:Helptags` to generate help tags |
| [NeoBundle][12] | `NeoBundle 'milesmanners/vim-stagehand'` |
| [Vundle][13] | `Plugin 'milesmanners/vim-stagehand'` |
| [Plug][40] | `Plug 'milesmanners/vim-stagehand'` |
| [VAM][22] | `call vam#ActivateAddons([ 'vim-stagehand' ])` |
| [Dein][52] | `call dein#add('milesmanners/vim-stagehand')` |
| [minpac][55] | `call minpac#add('milesmanners/vim-stagehand')` |
| pack feature (native Vim 8 package feature)| `git clone https://github.com/milesmanners/vim-stagehand ~/.vim/pack/dist/start/vim-stagehand`<br/>Remember to run `:helptags ~/.vim/pack/dist/start/vim-stagehand/doc` to generate help tags |
| manual | copy all of the files into your `~/.vim` directory |

## Self-Promotion

Like stagehand.vim?  Star the repository on
[GitHub](https://github.com/milesmanners/vim-stagehand)

Love surround.vim?  Follow [Miles Manners](https://repo.dmm.gg) on
[GitHub](https://github.com/milesmanners) and
[Twitter](http://twitter.com/milesmanners).

## License

Copyright (c) Joel Ewald.  Distributed under the same terms as Vim itself.
See `:help license`.
