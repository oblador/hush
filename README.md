<div align="center">
  <a href="https://oblador.github.io/hush"><img src="https://user-images.githubusercontent.com/378279/102943111-6dfe0500-44b7-11eb-9e9a-1c77d53a04ab.png" width="256" height="256"></a>
  <h1>Hush</h1>
  <p>
    <b>Block nags to accept cookies and privacy invasive tracking in Safari</b>
  </p>
  <br>
  <br>
  <br>
</div>

## Download

### iOS

[![](https://linkmaker.itunes.apple.com/assets/shared/badges/en-us/appstore-lrg.svg)](https://apps.apple.com/app/id1544743900)

Requires iOS 10.14 or later.

### macOS

Pending approval for Mac App Store. [Direct download](https://github.com/oblador/hush/releases/latest/download/Hush.dmg).

Requires macOS 11 or later.

## Screenshots

<img width="432" src="https://user-images.githubusercontent.com/378279/102943263-da790400-44b7-11eb-9c4e-ee6870da3c24.png">

## Building from source

To build the app in Xcode, you need to have [deno](https://deno.land) installed first:

```sh
brew install deno
xcode-select --install
```

## FAQ

#### Why does website X display nags with Hush enabled?

On some sites it's not possible to block/hide cookie notices or tracking consent screens without also breaking the site. Other sites have obfuscations in place to prevent blocking. Regardless, you may open an issue on GitHub or [fill in a form](https://docs.google.com/forms/d/e/1FAIpQLSeox139lwja1Yl94dIZLSg8Ga8Wt4PAWSmRwtIe7NPb7WtHMA/viewform) to report it.

#### Why does website X break with Hush enabled?

First ensure that it's actually Hush breaking it by disabling it in settings and reloading the page. If it works after this, please report it by opening an issue.

## License

Hush: [MIT License](http://opensource.org/licenses/mit-license.html). © Joel Arvidsson 2020-present

[Fanboy List](https://easylist.to): [CC BY 3.0](https://creativecommons.org/licenses/by/3.0/). © Rick Petnel and contributors 2005
