# stagehand.vim

Press `s` to take your current visual selection backstage.

Once you have it backstage, make as many edits as you want. When you save backstage, all your changes will come back to the original buffer like you had never left it.

For the real galaxy brain users out there, try combining stagehand with
[goyo.vim][goyo] and [limelight.vim][limelight]. Stagehand provides events for this purpose.

```vim
autocmd! User StagehandEnter Goyo
autocmd! User StagehandLeave Goyo!
```

## Installation

This plugin follows the standard runtime path structure, and as such it can be installed with a variety of plugin managers:

| Plugin Manager | Install with... |
| ------------- | ------------- |
| [Pathogen][pathogen] | `git clone https://github.com/milesmanners/vim-stagehand ~/.vim/bundle/vim-stagehand`<br/>Remember to run `:Helptags` to generate help tags |
| [NeoBundle][neobundle] | `NeoBundle 'milesmanners/vim-stagehand'` |
| [Vundle][vundle] | `Plugin 'milesmanners/vim-stagehand'` |
| [Plug][plug] | `Plug 'milesmanners/vim-stagehand'` |
| [VAM][vam] | `call vam#ActivateAddons([ 'vim-stagehand' ])` |
| [Dein][dein] | `call dein#add('milesmanners/vim-stagehand')` |
| [minpac][minpac] | `call minpac#add('milesmanners/vim-stagehand')` |
| pack feature (native Vim 8 package feature)| `git clone https://github.com/milesmanners/vim-stagehand ~/.vim/pack/dist/start/vim-stagehand`<br/>Remember to run `:helptags ~/.vim/pack/dist/start/vim-stagehand/doc` to generate help tags |
| manual | copy all of the files into your `~/.vim` directory |

## Self-Promotion

Like stagehand.vim?  Star the repository on
[GitHub][stagehand-github]

Love stagehand.vim?  Follow [Miles Manners][personal-site] on
[GitHub][personal-github] and
[Twitter][personal-twitter].

## License

Copyright (c) Joel Ewald.  Distributed under the same terms as Vim itself.
See `:help license`.

[stagehand-github]: https://github.com/milesmanners/vim-stagehand
[personal-site]: https://repo.dmm.gg
[personal-github]: https://github.com/milesmanners
[personal-twitter]: https://twitter.com/milesmanners
[goyo]: https://github.com/junegunn/goyo.vim
[limelight]: https://github.com/junegunn/limelight.vim
[pathogen]: https://github.com/tpope/vim-pathogen
[neobundle]: https://github.com/Shougo/neobundle.vim
[vundle]: https://github.com/VundleVim/Vundle.vim
[plug]: https://github.com/junegunn/vim-plug
[vam]: https://github.com/MarcWeber/vim-addon-manager
[dein]: https://github.com/Shougo/dein.vim
[minpac]: https://github.com/k-takata/minpac
