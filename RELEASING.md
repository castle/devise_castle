Releasing
=========

1. Update `VERSION` in `lib/devise_castle/version.rb` to the new version
3. `git commit -am "prepare for release X.Y.Z."` (where X.Y.Z is the new version)
4. `git tag -a vX.Y.Z -m "release X.Y.Z"` (where X.Y.Z is the new version)
5. `git push --tags`
6. New release on github
7. `gem build devise_castle.gemspec`
8. `gem push devise_castle-X.Y.Z.gem`
