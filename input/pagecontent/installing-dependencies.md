One dependency of this implementation guide is not on the FHIR package registry (packages.fhir.org), so SUSHI, the IG Publisher and the validator cannot download it:

| Package | URL | sha-256 |
|---|---|---|
| `nl.twiin.fhir.r4.notifications#0.1.1-draft` | https://fhir.twiin.nl/ig/notifications/0.1.1-draft/package.tgz | `cec58f60184740ec51994b44c5ae4ddc42b870576ff20cfc831f9a47a183f2fd` |

This is the URL and checksum used in the CI of this guide.

### Putting the packages in the local package cache

The tools read packages from the local FHIR package cache, `<home directory>/.fhir/packages`. A package sits in a folder `<id>#<version>`, with the contents of the tarball in a subfolder `package`. For the package:

```sh
curl -sSfL -o package.tgz <URL>
echo "<sha-256>  package.tgz" | shasum -a 256 -c -
mkdir -p ~/.fhir/packages/<id>#<version>
tar xzf package.tgz -C ~/.fhir/packages/<id>#<version>
```

For example, for `nl.twiin.fhir.r4.notifications#0.1.1-draft` the result is `~/.fhir/packages/nl.twiin.fhir.r4.notifications#0.1.1-draft/package/package.json`. Do not continue when the checksum differs.

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
