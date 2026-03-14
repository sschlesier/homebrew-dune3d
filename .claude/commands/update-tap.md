Check for a new upstream dune3d release and update the formula if one is available.

## Steps

1. Run `brew livecheck sschlesier/dune3d/dune3d` to check for a new version. If the formula is already current, report that and stop.

2. Read `Formula/dune3d.rb` to get the current version from the `url` field.

3. Construct the new tarball URL:
   `https://github.com/dune3d/dune3d/archive/refs/tags/vX.Y.Z.tar.gz`

4. Compute the sha256 of the new tarball:
   `curl -sL <url> | shasum -a 256`

5. Edit `Formula/dune3d.rb`:
   - Update the `url` to point to the new tag
   - Update the `sha256` to the value from step 4
   - Remove the entire `bottle do ... end` block (CI will regenerate it)

6. Commit and push:
   ```
   git add Formula/dune3d.rb
   git commit -m "feat: update dune3d to vX.Y.Z"
   git push
   ```

7. Report what was done and remind the user that CI will build the bottle and commit the `bottle do` block back automatically.
