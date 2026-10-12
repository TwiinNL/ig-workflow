Two dependencies of this implementation guide are not on the FHIR package registry (packages.fhir.org), so SUSHI, the IG Publisher and the validator cannot download them:

| Package | URL | sha-256 |
|---|---|---|
| `nl.generiekefuncties.csd#1.0.0` | https://minvws.github.io/generiekefuncties-docs/package.tgz | `847ea68d0ba5df6c0c2faa6a939d23f49e167401e338752d1ef72a3cf509c849` |
| `nl.twiin.fhir.r4.notifications#0.1.0-draft` | https://fhir.twiin.nl/ig/notifications/0.1.0-draft/package.tgz | `bcf5baf254979caba62508179ec46739aca488adbbbfafae96f90def6a7b192c` |

These are the URLs and checksums used in the CI of this guide. The URL of `nl.generiekefuncties.csd` has no version: it serves the package that was last built, so the checksum only matches the package this guide was built against.

### Putting the packages in the local package cache

The tools read packages from the local FHIR package cache, `<home directory>/.fhir/packages`. A package sits in a folder `<id>#<version>`, with the contents of the tarball in a subfolder `package`. For each package:

```sh
curl -sSfL -o package.tgz <URL>
echo "<sha-256>  package.tgz" | shasum -a 256 -c -
mkdir -p ~/.fhir/packages/<id>#<version>
tar xzf package.tgz -C ~/.fhir/packages/<id>#<version>
```

For example, for `nl.twiin.fhir.r4.notifications#0.1.0-draft` the result is `~/.fhir/packages/nl.twiin.fhir.r4.notifications#0.1.0-draft/package/package.json`. Do not continue when the checksum differs.

SUSHI, the IG Publisher and the validator find the packages in the cache without further configuration, as long as the version in the dependency of the guide equals the folder name.

The source repository of this guide has a script that does this, including the checksum check: `.github/scripts/install-packages.sh`.

### Dependencies of this guide

{% include dependency-table.xhtml %}

### IP statements

{% include ip-statements.xhtml %}

### Global profiles

{% include globals-table.xhtml %}

### Source

- Location of the cache: [FHIR Package Loader](https://github.com/FHIR/fhir-package-loader#packageloader-implementations) (used by SUSHI): "the standard FHIR cache is used for local storage of unzipped packages (`$USER_HOME/.fhir/packages`)"; for the IG Publisher and validator, `FilesystemPackageCacheManager` in [hapifhir/org.hl7.fhir.core](https://github.com/hapifhir/org.hl7.fhir.core) (`user.home`, `.fhir`, `packages`; folder `<id>#<version>`). The specification only says that tools may use a common local cache ([FHIR packages, FHIR Package Caching](https://build.fhir.org/packages.html)).
- The `package` subfolder follows from the layout of the tarballs and was checked against the cache of a working local build.
