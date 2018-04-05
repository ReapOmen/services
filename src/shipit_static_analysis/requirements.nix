# generated using pypi2nix tool (version: 1.8.1)
# See more at: https://github.com/garbas/pypi2nix
#
# COMMAND:
#   pypi2nix -v -V 3.5 -E libffi openssl pkgconfig freetype.dev -r requirements.txt -r requirements-dev.txt
#

{ pkgs ? import <nixpkgs> {}
}:

let

  inherit (pkgs) makeWrapper;
  inherit (pkgs.stdenv.lib) fix' extends inNixShell;

  pythonPackages =
  import "${toString pkgs.path}/pkgs/top-level/python-packages.nix" {
    inherit pkgs;
    inherit (pkgs) stdenv;
    python = pkgs.python35;
    # patching pip so it does not try to remove files when running nix-shell
    overrides =
      self: super: {
        bootstrapped-pip = super.bootstrapped-pip.overrideDerivation (old: {
          patchPhase = old.patchPhase + ''
            sed -i \
              -e "s|paths_to_remove.remove(auto_confirm)|#paths_to_remove.remove(auto_confirm)|"  \
              -e "s|self.uninstalled = paths_to_remove|#self.uninstalled = paths_to_remove|"  \
                $out/${pkgs.python35.sitePackages}/pip/req/req_install.py
          '';
        });
      };
  };

  commonBuildInputs = with pkgs; [ libffi openssl pkgconfig freetype.dev ];
  commonDoCheck = false;

  withPackages = pkgs':
    let
      pkgs = builtins.removeAttrs pkgs' ["__unfix__"];
      interpreter = pythonPackages.buildPythonPackage {
        name = "python35-interpreter";
        buildInputs = [ makeWrapper ] ++ (builtins.attrValues pkgs);
        buildCommand = ''
          mkdir -p $out/bin
          ln -s ${pythonPackages.python.interpreter} \
              $out/bin/${pythonPackages.python.executable}
          for dep in ${builtins.concatStringsSep " "
              (builtins.attrValues pkgs)}; do
            if [ -d "$dep/bin" ]; then
              for prog in "$dep/bin/"*; do
                if [ -x "$prog" ] && [ -f "$prog" ]; then
                  ln -s $prog $out/bin/`basename $prog`
                fi
              done
            fi
          done
          for prog in "$out/bin/"*; do
            wrapProgram "$prog" --prefix PYTHONPATH : "$PYTHONPATH"
          done
          pushd $out/bin
          ln -s ${pythonPackages.python.executable} python
          ln -s ${pythonPackages.python.executable} \
              python3
          popd
        '';
        passthru.interpreter = pythonPackages.python;
      };
    in {
      __old = pythonPackages;
      inherit interpreter;
      mkDerivation = pythonPackages.buildPythonPackage;
      packages = pkgs;
      overrideDerivation = drv: f:
        pythonPackages.buildPythonPackage (
          drv.drvAttrs // f drv.drvAttrs // { meta = drv.meta; }
        );
      withPackages = pkgs'':
        withPackages (pkgs // pkgs'');
    };

  python = withPackages {};

  generated = self: {
    "Logbook" = python.mkDerivation {
      name = "Logbook-1.3.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/27/02/e18f2275048ade1288e75e2d09f86e54fdaba0440e190d7adfdc4636f63d/Logbook-1.3.0.tar.gz"; sha256 = "f44562b4ecf529046db0e0a80ee145217c865966834e85479352d986a455488b"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."pytest"
      self."pytest-cov"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://logbook.pocoo.org/";
        license = licenses.bsdOriginal;
        description = "A logging replacement for Python";
      };
    };

    "PyYAML" = python.mkDerivation {
      name = "PyYAML-3.12";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"; sha256 = "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pyyaml.org/wiki/PyYAML";
        license = licenses.mit;
        description = "YAML parser and emitter for Python";
      };
    };

    "Pygments" = python.mkDerivation {
      name = "Pygments-2.2.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"; sha256 = "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pygments.org/";
        license = licenses.bsdOriginal;
        description = "Pygments is a syntax highlighting package written in Python.";
      };
    };

    "RBTools" = python.mkDerivation {
      name = "RBTools-0.7.11";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/76/00/08ff68a170f7a074e01a837f765c0c6617683f22ec6bb89b048d34e316b1/RBTools-0.7.11.tar.gz"; sha256 = "26de153a76d6a3c5bea3442151473857a74338c18ff628acfcfa6c258998f258"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."six"
      self."tqdm"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.reviewboard.org/";
        license = licenses.mit;
        description = "Command line tools for use with Review Board";
      };
    };

    "aioamqp" = python.mkDerivation {
      name = "aioamqp-0.10.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/22/f2/2b78c982e81eb840de18a419aa5c7d10519ccd81852e91310ebcbcd3e78b/aioamqp-0.10.0.tar.gz"; sha256 = "c618af6d005942a2a8711f7548348f9028fac2673f0dc2d192310cef83486204"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."asyncio"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/polyconseil/aioamqp";
        license = licenses.bsdOriginal;
        description = "AMQP implementation using asyncio";
      };
    };

    "aiohttp" = python.mkDerivation {
      name = "aiohttp-2.3.10";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/c0/b9/853b158f5cb5d218daaff0fb0dbc2bd7de45b2c6c5f563dff0ee530ec52a/aiohttp-2.3.10.tar.gz"; sha256 = "8adda6583ba438a4c70693374e10b60168663ffa6564c5c75d3c7a9055290964"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."async-timeout"
      self."chardet"
      self."idna-ssl"
      self."multidict"
      self."yarl"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/aio-libs/aiohttp/";
        license = licenses.asl20;
        description = "Async http client/server framework (asyncio)";
      };
    };

    "async-timeout" = python.mkDerivation {
      name = "async-timeout-1.4.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/6f/cc/ff80612164fe68bf97767052c5c783a033165df7d47a41ae5c1cc5ea480b/async-timeout-1.4.0.tar.gz"; sha256 = "983891535b1eca6ba82b9df671c8abff53c804fce3fa630058da5bbbda500340"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/aio-libs/async_timeout/";
        license = licenses.asl20;
        description = "Timeout context manager for asyncio programs";
      };
    };

    "asyncio" = python.mkDerivation {
      name = "asyncio-3.4.3";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/da/54/054bafaf2c0fb8473d423743e191fcdf49b2c1fd5e9af3524efbe097bafd/asyncio-3.4.3.tar.gz"; sha256 = "83360ff8bc97980e4ff25c964c7bd3923d333d177aa4f7fb736b019f26c7cb41"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.python.org/dev/peps/pep-3156/";
        license = "";
        description = "reference implementation of PEP 3156";
      };
    };

    "attrs" = python.mkDerivation {
      name = "attrs-17.4.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/8b/0b/a06cfcb69d0cb004fde8bc6f0fd192d96d565d1b8aa2829f0f20adb796e5/attrs-17.4.0.tar.gz"; sha256 = "1c7960ccfd6a005cd9f7ba884e6316b5e430a3f1a6c37c5f87d8b43f83b54ec9"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."coverage"
      self."pytest"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.attrs.org/";
        license = licenses.mit;
        description = "Classes Without Boilerplate";
      };
    };

    "backcall" = python.mkDerivation {
      name = "backcall-0.1.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/84/71/c8ca4f5bb1e08401b916c68003acf0a0655df935d74d93bf3f3364b310e0/backcall-0.1.0.tar.gz"; sha256 = "38ecd85be2c1e78f77fd91700c76e14667dc21e2713b63876c0eb901196e01e4"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/takluyver/backcall";
        license = licenses.bsdOriginal;
        description = "Specifications for callback functions passed in to an API";
      };
    };

    "boto3" = python.mkDerivation {
      name = "boto3-1.7.1";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/3c/6c/00b00fadb060b8baeb666999807d7ce85d194aedcfb2e09b149b2392bae3/boto3-1.7.1.tar.gz"; sha256 = "91348d9e5c33c2c1aaaa238a3e97be4834c1aff85082ef6d9b249814be20bab4"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."botocore"
      self."jmespath"
      self."s3transfer"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/boto/boto3";
        license = licenses.asl20;
        description = "The AWS SDK for Python";
      };
    };

    "botocore" = python.mkDerivation {
      name = "botocore-1.10.1";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/0b/3e/7a2299870d01611e221648484146bed16da2bc69fb256d4b2669c26fea32/botocore-1.10.1.tar.gz"; sha256 = "bc1e6c36b1b570462e3b688b3bd3ba662e521cc21ce0a860f85f877179af77c7"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."docutils"
      self."jmespath"
      self."python-dateutil"
      self."simplejson"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/boto/botocore";
        license = licenses.asl20;
        description = "Low-level, data-driven core of boto 3.";
      };
    };

    "certifi" = python.mkDerivation {
      name = "certifi-2018.1.18";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/15/d4/2f888fc463d516ff7bf2379a4e9a552fef7f22a94147655d9b1097108248/certifi-2018.1.18.tar.gz"; sha256 = "edbc3f203427eef571f79a7692bb160a2b0f7ccaa31953e99bd17e307cf63f7d"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://certifi.io/";
        license = licenses.mpl20;
        description = "Python package for providing Mozilla's CA Bundle.";
      };
    };

    "chardet" = python.mkDerivation {
      name = "chardet-3.0.4";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"; sha256 = "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/chardet/chardet";
        license = licenses.lgpl2;
        description = "Universal encoding detector for Python 2 and 3";
      };
    };

    "click" = python.mkDerivation {
      name = "click-6.7";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"; sha256 = "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/mitsuhiko/click";
        license = licenses.bsdOriginal;
        description = "A simple wrapper around optparse for powerful command line utilities.";
      };
    };

    "codecov" = python.mkDerivation {
      name = "codecov-2.0.15";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/77/f2/9790ee0f04eb0571841aff5ba1709c7869e82aa2145a04a3d4770807ff50/codecov-2.0.15.tar.gz"; sha256 = "8ed8b7c6791010d359baed66f84f061bba5bd41174bf324c31311e8737602788"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."coverage"
      self."requests"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/codecov/codecov-python";
        license = "License :: OSI Approved :: Apache Software License";
        description = "Hosted coverage reports for Github, Bitbucket and Gitlab";
      };
    };

    "codespell" = python.mkDerivation {
      name = "codespell-1.12.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/29/85/8098b4252e1ed5f39e9b83db96cd9105ef2572ba1a14a165f7023e86c766/codespell-1.12.0.tar.gz"; sha256 = "f547ef6ea3af4569b0a4d3ef106ef6403f6ee574afdaa8e332650aea87301daf"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/lucasdemarchi/codespell/";
        license = "License :: OSI Approved";
        description = "Codespell";
      };
    };

    "cookies" = python.mkDerivation {
      name = "cookies-2.2.1";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/f3/95/b66a0ca09c5ec9509d8729e0510e4b078d2451c5e33f47bd6fc33c01517c/cookies-2.2.1.tar.gz"; sha256 = "d6b698788cae4cfa4e62ef8643a9ca332b79bd96cb314294b864ae8d7eb3ee8e"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/sashahart/cookies";
        license = licenses.mit;
        description = "Friendlier RFC 6265-compliant cookie parser/renderer";
      };
    };

    "coverage" = python.mkDerivation {
      name = "coverage-4.5.1";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/35/fe/e7df7289d717426093c68d156e0fd9117c8f4872b6588e8a8928a0f68424/coverage-4.5.1.tar.gz"; sha256 = "56e448f051a201c5ebbaa86a5efd0ca90d327204d8b059ab25ad0f35fbfd79f1"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://bitbucket.org/ned/coveragepy";
        license = licenses.asl20;
        description = "Code coverage measurement for Python";
      };
    };

    "coveralls" = python.mkDerivation {
      name = "coveralls-1.3.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/3e/dd/61b1365f2d1d3fc459f9e3d36d9c8824fb3c9cd6bf5ee721ca6c8f68c164/coveralls-1.3.0.tar.gz"; sha256 = "664794748d2e5673e347ec476159a9d87f43e0d2d44950e98ed0e27b98da8346"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."PyYAML"
      self."coverage"
      self."docopt"
      self."requests"
      self."urllib3"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/coveralls-clients/coveralls-python";
        license = licenses.mit;
        description = "Show coverage stats online via coveralls.io";
      };
    };

    "datadog" = python.mkDerivation {
      name = "datadog-0.20.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/36/29/4c3340db9f5d0ff27e3ce7af621cff4f9b8b45dc3191a445037972fb4757/datadog-0.20.0.tar.gz"; sha256 = "7bb4af836d7422a6138f983b81c16acd56c2d608913982602856cc273ae74768"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."decorator"
      self."requests"
      self."simplejson"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://www.datadoghq.com";
        license = licenses.bsdOriginal;
        description = "The Datadog Python library";
      };
    };

    "decorator" = python.mkDerivation {
      name = "decorator-4.2.1";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/70/f1/cb9373195639db13063f55eb06116310ad691e1fd125e6af057734dc44ea/decorator-4.2.1.tar.gz"; sha256 = "7d46dd9f3ea1cf5f06ee0e4e1277ae618cf48dfb10ada7c8427cd46c42702a0e"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/micheles/decorator";
        license = licenses.bsdOriginal;
        description = "Better living through Python with decorators";
      };
    };

    "docopt" = python.mkDerivation {
      name = "docopt-0.6.2";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"; sha256 = "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://docopt.org";
        license = licenses.mit;
        description = "Pythonic argument parser, that will make you smile";
      };
    };

    "docutils" = python.mkDerivation {
      name = "docutils-0.14";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz"; sha256 = "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://docutils.sourceforge.net/";
        license = licenses.publicDomain;
        description = "Docutils -- Python Documentation Utilities";
      };
    };

    "fancycompleter" = python.mkDerivation {
      name = "fancycompleter-0.8";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/fd/e3/da39a6cfaffe578a01221261ac1d5d99c48d44f6377ff0de3a12dd332cec/fancycompleter-0.8.tar.gz"; sha256 = "d2522f1f3512371f295379c4c0d1962de06762eb586c199620a2a5d423539b12"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://bitbucket.org/antocuni/fancycompleter";
        license = licenses.bsdOriginal;
        description = "colorful TAB completion for Python prompt";
      };
    };

    "flake8" = python.mkDerivation {
      name = "flake8-3.5.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/1e/ab/7730f6d6cdf73a3b7f98a2fe3b2cdf68e9e760a4a133e083607497d4c3a6/flake8-3.5.0.tar.gz"; sha256 = "7253265f7abd8b313e3892944044a365e3f4ac3fcdcfb4298f55ee9ddf188ba0"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."mccabe"
      self."pycodestyle"
      self."pyflakes"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://gitlab.com/pycqa/flake8";
        license = licenses.mit;
        description = "the modular source code checker: pep8, pyflakes and co";
      };
    };

    "flake8-coding" = python.mkDerivation {
      name = "flake8-coding-1.3.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/ae/26/3c6304d646f8ee27d6c40bfcd9874fea870098c3ef3cf60e284ea9db29ef/flake8-coding-1.3.0.tar.gz"; sha256 = "ba01e96f879377766a3d71f3499a832b19386ce4831270bfe671ab57d0fe50be"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."flake8"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/tk0miya/flake8-coding";
        license = licenses.asl20;
        description = "Adds coding magic comment checks to flake8";
      };
    };

    "flake8-copyright" = python.mkDerivation {
      name = "flake8-copyright-0.2.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/3a/22/2973cbdfd5c2df98bbd1b187c19c438653ffa75ea2ed1b0e610b344d70b6/flake8-copyright-0.2.0.tar.gz"; sha256 = "aeef26eb4d5223c9cd5b101e68175fcef6d2b353bf36da688fdde62fccfe2b73"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/savoirfairelinux/flake8-copyright";
        license = "";
        description = "Adds copyright checks to flake8";
      };
    };

    "flake8-debugger" = python.mkDerivation {
      name = "flake8-debugger-3.1.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/39/4b/90548607282483dd15f9ce1f4434d735ae756e16e1faf60621b0f8877fcc/flake8-debugger-3.1.0.tar.gz"; sha256 = "be4fb88de3ee8f6dd5053a2d347e2c0a2b54bab6733a2280bb20ebd3c4ca1d97"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."flake8"
      self."pycodestyle"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/jbkahn/flake8-debugger";
        license = licenses.mit;
        description = "ipdb/pdb statement checker plugin for flake8";
      };
    };

    "flake8-isort" = python.mkDerivation {
      name = "flake8-isort-2.5";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/07/ad/d8d87f1dc4f2ab398ba9e9ad603367d14ba7d614dad7dece66ae0148541b/flake8-isort-2.5.tar.gz"; sha256 = "298d7904ac3a46274edf4ce66fd7e272c2a60c34c3cc999dea000608d64e5e6e"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."flake8"
      self."isort"
      self."pytest"
      self."testfixtures"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/gforcada/flake8-isort";
        license = licenses.gpl2;
        description = "flake8 plugin that integrates isort .";
      };
    };

    "flake8-mypy" = python.mkDerivation {
      name = "flake8-mypy-17.8.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/97/9a/cddd1363d7314bb4eb452089c6fb3092ed9fda9f3350683d1978522a30ec/flake8-mypy-17.8.0.tar.gz"; sha256 = "47120db63aff631ee1f84bac6fe8e64731dc66da3efc1c51f85e15ade4a3ba18"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."attrs"
      self."flake8"
      self."mypy"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/ambv/flake8-mypy";
        license = licenses.mit;
        description = "A plugin for flake8 integrating mypy.";
      };
    };

    "flake8-quotes" = python.mkDerivation {
      name = "flake8-quotes-0.14.1";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/1c/6e/33b5f1add3fa2e0ecdcda6267d6154bdeb51d39586a058b698002da1ccab/flake8-quotes-0.14.1.tar.gz"; sha256 = "00c53e41be1cf6d04c4e5974a36320b081ee7e13fc394457a104836cbfc1399e"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."flake8"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/zheller/flake8-quotes/";
        license = licenses.mit;
        description = "Flake8 lint for quotes.";
      };
    };

    "httpretty" = python.mkDerivation {
      name = "httpretty-0.8.14";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/7c/7d/fdc08c3ecc0d49cb95cb67fd03034915e0f8d714b18f4d739c062a10a95c/httpretty-0.8.14.tar.gz"; sha256 = "83c176bbac9d68a45a5cca54f2d5be7e6b16a063adf6f334e7fd0eee272e976e"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/gabrielfalcao/httpretty";
        license = licenses.mit;
        description = "HTTP client mock for Python";
      };
    };

    "idna" = python.mkDerivation {
      name = "idna-2.6";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"; sha256 = "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/kjd/idna";
        license = licenses.bsdOriginal;
        description = "Internationalized Domain Names in Applications (IDNA)";
      };
    };

    "idna-ssl" = python.mkDerivation {
      name = "idna-ssl-1.0.1";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/c4/3b/facf5a5009e577e7764e68a2af5ee25c63f41c78277260c2c42b8cfabf2e/idna-ssl-1.0.1.tar.gz"; sha256 = "1293f030bc608e9aa9cdee72aa93c1521bbb9c7698068c61c9ada6772162b979"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."idna"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/aio-libs/idna-ssl";
        license = licenses.mit;
        description = "Patch ssl.match_hostname for Unicode(idna) domains support";
      };
    };

    "ipdb" = python.mkDerivation {
      name = "ipdb-0.11";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/80/fe/4564de08f174f3846364b3add8426d14cebee228f741c27e702b2877e85b/ipdb-0.11.tar.gz"; sha256 = "7081c65ed7bfe7737f83fa4213ca8afd9617b42ff6b3f1daf9a3419839a2a00a"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."ipython"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/gotcha/ipdb";
        license = licenses.bsdOriginal;
        description = "IPython-enabled pdb";
      };
    };

    "ipython" = python.mkDerivation {
      name = "ipython-6.3.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/a5/17/e296678250771b0ffaa4ad11e6e60ad14b2f734c902ee92a745d9fe64b7c/ipython-6.3.0.tar.gz"; sha256 = "c785ab502b1a63624baeb89fedb873a118d4da6c9a796ae06e4f4aaef74e9ea0"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Pygments"
      self."backcall"
      self."decorator"
      self."jedi"
      self."pexpect"
      self."pickleshare"
      self."prompt-toolkit"
      self."requests"
      self."simplegeneric"
      self."traitlets"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://ipython.org";
        license = licenses.bsdOriginal;
        description = "IPython: Productive Interactive Computing";
      };
    };

    "ipython-genutils" = python.mkDerivation {
      name = "ipython-genutils-0.2.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/e8/69/fbeffffc05236398ebfcfb512b6d2511c622871dca1746361006da310399/ipython_genutils-0.2.0.tar.gz"; sha256 = "eb2e116e75ecef9d4d228fdc66af54269afa26ab4463042e33785b887c628ba8"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://ipython.org";
        license = licenses.bsdOriginal;
        description = "Vestigial utilities from IPython";
      };
    };

    "isort" = python.mkDerivation {
      name = "isort-4.3.4";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/b1/de/a628d16fdba0d38cafb3d7e34d4830f2c9cb3881384ce5c08c44762e1846/isort-4.3.4.tar.gz"; sha256 = "b9c40e9750f3d77e6e4d441d8b0266cf555e7cdabdcff33c4fd06366ca761ef8"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/timothycrosley/isort";
        license = licenses.mit;
        description = "A Python utility / library to sort Python imports.";
      };
    };

    "jedi" = python.mkDerivation {
      name = "jedi-0.11.1";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/d2/41/430b325e411d564b1afc37bc7286c3549f4c415ada750a617fb1943c593d/jedi-0.11.1.tar.gz"; sha256 = "d6e799d04d1ade9459ed0f20de47c32f2285438956a677d083d3c98def59fa97"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."docopt"
      self."parso"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/davidhalter/jedi";
        license = licenses.mit;
        description = "An autocompletion tool for Python that can be used for text editors.";
      };
    };

    "jmespath" = python.mkDerivation {
      name = "jmespath-0.9.3";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/e5/21/795b7549397735e911b032f255cff5fb0de58f96da794274660bca4f58ef/jmespath-0.9.3.tar.gz"; sha256 = "6a81d4c9aa62caf061cb517b4d9ad1dd300374cd4706997aff9cd6aedd61fc64"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/jmespath/jmespath.py";
        license = licenses.mit;
        description = "JSON Matching Expressions";
      };
    };

    "mccabe" = python.mkDerivation {
      name = "mccabe-0.6.1";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/06/18/fa675aa501e11d6d6ca0ae73a101b2f3571a565e0f7d38e062eec18a91ee/mccabe-0.6.1.tar.gz"; sha256 = "dd8d182285a0fe56bace7f45b5e7d1a6ebcbf524e8f3bd87eb0f125271b8831f"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pycqa/mccabe";
        license = licenses.mit;
        description = "McCabe checker, plugin for flake8";
      };
    };

    "mohawk" = python.mkDerivation {
      name = "mohawk-0.3.4";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/19/22/10f696548a8d41ad41b92ab6c848c60c669e18c8681c179265ce4d048b03/mohawk-0.3.4.tar.gz"; sha256 = "e98b331d9fa9ece7b8be26094cbe2d57613ae882133cc755167268a984bc0ab3"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/kumar303/mohawk";
        license = licenses.mpl20;
        description = "Library for Hawk HTTP authorization";
      };
    };

    "more-itertools" = python.mkDerivation {
      name = "more-itertools-4.1.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/db/0b/f5660bf6299ec5b9f17bd36096fa8148a1c843fa77ddfddf9bebac9301f7/more-itertools-4.1.0.tar.gz"; sha256 = "c9ce7eccdcb901a2c75d326ea134e0886abfbea5f93e91cc95de9507c0816c44"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/erikrose/more-itertools";
        license = licenses.mit;
        description = "More routines for operating on iterables, beyond itertools";
      };
    };

    "mozdef-client" = python.mkDerivation {
      name = "mozdef-client-1.0.11";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/cd/9b/d783ba277e2120add2709e45db926f8e916c5933df2db9725b7787884ae5/mozdef_client-1.0.11.tar.gz"; sha256 = "86b8c7065c21ce07d3095b5772f70fa152fe97258cde22311e5db4e34f5be26d"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."boto3"
      self."pytz"
      self."requests-futures"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/gdestuynder/mozdef_client";
        license = licenses.mpl20;
        description = "A client library to send messages/events using MozDef";
      };
    };

    "mozilla-cli-common" = python.mkDerivation {
      name = "mozilla-cli-common-1.0.0";
      src = pkgs.lib.cleanSource ./../../lib/cli_common;
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Logbook"
      self."aioamqp"
      self."asyncio"
      self."click"
      self."mozdef-client"
      self."python-dateutil"
      self."python-hglib"
      self."raven"
      self."structlog"
      self."taskcluster"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/mozilla-releng/services";
        license = "MPL2";
        description = "Services behind https://mozilla-releng.net";
      };
    };

    "multidict" = python.mkDerivation {
      name = "multidict-4.1.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/ea/eb/c79ed6ff320ac8e935dcbff8a8833f1afb35c2433bff5bf1c9dabbd631b2/multidict-4.1.0.tar.gz"; sha256 = "fb4412490324705dcd2172baa8a3ea58ae23c5f982476805cad58ae929fe2a52"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/aio-libs/multidict/";
        license = licenses.asl20;
        description = "multidict implementation";
      };
    };

    "mypy" = python.mkDerivation {
      name = "mypy-0.580";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/3d/5f/86f955690ba3962d6158cd5b720bc53a0713f3e65ac2d14d106bbcb0a88e/mypy-0.580.tar.gz"; sha256 = "3bd95a1369810f7693366911d85be9f0a0bd994f6cb7162b7a994e5ded90e3d9"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."typed-ast"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.mypy-lang.org/";
        license = licenses.mit;
        description = "Optional static typing for Python";
      };
    };

    "parsepatch" = python.mkDerivation {
      name = "parsepatch-0.1.1";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/0e/12/803339a56eb6d7685c0566801b98ef1d4aa7cef9d3821ec8f589882e8f00/parsepatch-0.1.1.tar.gz"; sha256 = "7df8c3e4943e04ff52f17038523a72ff85ef5800f27cc457671b0fc448331876"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."requests"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/mozilla/parsepatch";
        license = "MPL";
        description = "Library to parse patches in an efficient manner";
      };
    };

    "parso" = python.mkDerivation {
      name = "parso-0.1.1";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/14/3b/15cfd9c7a8bd9e3a2fe956e20fbc4e7c5768e06aea347d8eb68a05a71653/parso-0.1.1.tar.gz"; sha256 = "5815f3fe254e5665f3c5d6f54f086c2502035cb631a91341591b5a564203cffb"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/davidhalter/parso";
        license = licenses.mit;
        description = "A Python Parser";
      };
    };

    "pathspec" = python.mkDerivation {
      name = "pathspec-0.5.5";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/9f/fb/5a901a3b1eeebf83af6da74ecca69d7daf5189e450f0f4cccf9c19132651/pathspec-0.5.5.tar.gz"; sha256 = "72c495d1bbe76674219e307f6d1c6062f2e1b0b483a5e4886435127d0df3d0d3"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/cpburnz/python-path-specification";
        license = licenses.mpl20;
        description = "Utility library for gitignore style pattern matching of file paths.";
      };
    };

    "pdbpp" = python.mkDerivation {
      name = "pdbpp-0.9.2";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/e6/cc/8bf81f5e53daa4a90d696fa430c2f4e709656e2bf953686bd15c0746616f/pdbpp-0.9.2.tar.gz"; sha256 = "dde77326e4ea41439c243ed065826d53539530eeabd1b6615aae15cfbb9fda05"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Pygments"
      self."fancycompleter"
      self."wmctrl"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/antocuni/pdb";
        license = licenses.bsdOriginal;
        description = "pdb++, a drop-in replacement for pdb";
      };
    };

    "pexpect" = python.mkDerivation {
      name = "pexpect-4.4.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/fa/c3/60c0cbf96f242d0b47a82e9ca634dcd6dcb043832cf05e17540812e1c707/pexpect-4.4.0.tar.gz"; sha256 = "67b85a1565968e3d5b5e7c9283caddc90c3947a2625bed1905be27bd5a03e47d"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."ptyprocess"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://pexpect.readthedocs.io/";
        license = licenses.isc;
        description = "Pexpect allows easy control of interactive console applications.";
      };
    };

    "pickleshare" = python.mkDerivation {
      name = "pickleshare-0.7.4";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/69/fe/dd137d84daa0fd13a709e448138e310d9ea93070620c9db5454e234af525/pickleshare-0.7.4.tar.gz"; sha256 = "84a9257227dfdd6fe1b4be1319096c20eb85ff1e82c7932f36efccfe1b09737b"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pickleshare/pickleshare";
        license = licenses.mit;
        description = "Tiny 'shelve'-like database with concurrency support";
      };
    };

    "pluggy" = python.mkDerivation {
      name = "pluggy-0.6.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/11/bf/cbeb8cdfaffa9f2ea154a30ae31a9d04a1209312e2919138b4171a1f8199/pluggy-0.6.0.tar.gz"; sha256 = "7f8ae7f5bdf75671a718d2daf0a64b7885f74510bcd98b1a0bb420eb9a9d0cff"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pytest-dev/pluggy";
        license = licenses.mit;
        description = "plugin and hook calling mechanisms for python";
      };
    };

    "prompt-toolkit" = python.mkDerivation {
      name = "prompt-toolkit-1.0.15";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/8a/ad/cf6b128866e78ad6d7f1dc5b7f99885fb813393d9860778b2984582e81b5/prompt_toolkit-1.0.15.tar.gz"; sha256 = "858588f1983ca497f1cf4ffde01d978a3ea02b01c8a26a8bbc5cd2e66d816917"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."six"
      self."wcwidth"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/jonathanslenders/python-prompt-toolkit";
        license = licenses.bsdOriginal;
        description = "Library for building powerful interactive command lines in Python";
      };
    };

    "ptyprocess" = python.mkDerivation {
      name = "ptyprocess-0.5.2";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/51/83/5d07dc35534640b06f9d9f1a1d2bc2513fb9cc7595a1b0e28ae5477056ce/ptyprocess-0.5.2.tar.gz"; sha256 = "e64193f0047ad603b71f202332ab5527c5e52aa7c8b609704fc28c0dc20c4365"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pexpect/ptyprocess";
        license = "";
        description = "Run a subprocess in a pseudo terminal";
      };
    };

    "py" = python.mkDerivation {
      name = "py-1.5.3";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/f7/84/b4c6e84672c4ceb94f727f3da8344037b62cee960d80e999b1cd9b832d83/py-1.5.3.tar.gz"; sha256 = "29c9fab495d7528e80ba1e343b958684f4ace687327e6f789a94bf3d1915f881"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://py.readthedocs.io/";
        license = licenses.mit;
        description = "library with cross-python path, ini-parsing, io, code, log facilities";
      };
    };

    "pyasn1" = python.mkDerivation {
      name = "pyasn1-0.3.4";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/1a/37/7ac6910d872fdac778ad58c82018dce4af59279a79b17403bbabbe2a866e/pyasn1-0.3.4.tar.gz"; sha256 = "3946ff0ab406652240697013a89d76e388344866033864ef2b097228d1f0101a"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/etingof/pyasn1";
        license = licenses.bsdOriginal;
        description = "ASN.1 types and codecs";
      };
    };

    "pycodestyle" = python.mkDerivation {
      name = "pycodestyle-2.3.1";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/e1/88/0e2cbf412bd849ea6f1af1f97882add46a374f4ba1d2aea39353609150ad/pycodestyle-2.3.1.tar.gz"; sha256 = "682256a5b318149ca0d2a9185d365d8864a768a28db66a84a2ea946bcc426766"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://pycodestyle.readthedocs.io/";
        license = licenses.mit;
        description = "Python style guide checker";
      };
    };

    "pyflakes" = python.mkDerivation {
      name = "pyflakes-1.6.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/26/85/f6a315cd3c1aa597fb3a04cc7d7dbea5b3cc66ea6bd13dfa0478bf4876e6/pyflakes-1.6.0.tar.gz"; sha256 = "8d616a382f243dbf19b54743f280b80198be0bca3a5396f1d2e1fca6223e8805"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/PyCQA/pyflakes";
        license = licenses.mit;
        description = "passive checker of Python programs";
      };
    };

    "pytest" = python.mkDerivation {
      name = "pytest-3.5.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/2d/56/6019153cdd743300c5688ab3b07702355283e53c83fbf922242c053ffb7b/pytest-3.5.0.tar.gz"; sha256 = "fae491d1874f199537fd5872b5e1f0e74a009b979df9d53d1553fd03da1703e1"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."attrs"
      self."more-itertools"
      self."pluggy"
      self."py"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pytest.org";
        license = licenses.mit;
        description = "pytest: simple powerful testing with Python";
      };
    };

    "pytest-cov" = python.mkDerivation {
      name = "pytest-cov-2.5.1";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/24/b4/7290d65b2f3633db51393bdf8ae66309b37620bc3ec116c5e357e3e37238/pytest-cov-2.5.1.tar.gz"; sha256 = "03aa752cf11db41d281ea1d807d954c4eda35cfa1b21d6971966cc041bbf6e2d"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."coverage"
      self."pytest"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pytest-dev/pytest-cov";
        license = licenses.bsdOriginal;
        description = "Pytest plugin for measuring coverage.";
      };
    };

    "python-dateutil" = python.mkDerivation {
      name = "python-dateutil-2.6.1";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/54/bb/f1db86504f7a49e1d9b9301531181b00a1c7325dc85a29160ee3eaa73a54/python-dateutil-2.6.1.tar.gz"; sha256 = "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://dateutil.readthedocs.io";
        license = licenses.bsdOriginal;
        description = "Extensions to the standard Python datetime module";
      };
    };

    "python-hglib" = python.mkDerivation {
      name = "python-hglib-2.5";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/5a/c8/b8c95d3ee5d57c7961d918c16a09ebb8b3122a87e373bbda9f1f35769ff3/python-hglib-2.5.tar.gz"; sha256 = "fee180bb6796e5d2d25158b2d3c9f048648e427dd28b23a58d369adb14dd67cb"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://www.mercurial-scm.org/wiki/PythonHglibs";
        license = licenses.mit;
        description = "Mercurial Python library";
      };
    };

    "pytz" = python.mkDerivation {
      name = "pytz-2018.3";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/1b/50/4cdc62fc0753595fc16c8f722a89740f487c6e5670c644eb8983946777be/pytz-2018.3.tar.gz"; sha256 = "410bcd1d6409026fbaa65d9ed33bf6dd8b1e94a499e32168acfc7b332e4095c0"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pythonhosted.org/pytz";
        license = licenses.mit;
        description = "World timezone definitions, modern and historical";
      };
    };

    "raven" = python.mkDerivation {
      name = "raven-6.6.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/03/8a/f28e01894cbd34c9c33dce88fc9e1a39c8930f9d1ed8e35a8d5499083af8/raven-6.6.0.tar.gz"; sha256 = "92bf4c4819472ed20f1b9905eeeafe1bc6fe5f273d7c14506fdb8fb3a6ab2074"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Logbook"
      self."coverage"
      self."flake8"
      self."pycodestyle"
      self."pytest"
      self."pytest-cov"
      self."pytz"
      self."requests"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/getsentry/raven-python";
        license = licenses.bsdOriginal;
        description = "Raven is a client for Sentry (https://getsentry.com)";
      };
    };

    "requests" = python.mkDerivation {
      name = "requests-2.18.4";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"; sha256 = "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."certifi"
      self."chardet"
      self."idna"
      self."urllib3"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://python-requests.org";
        license = licenses.asl20;
        description = "Python HTTP for Humans.";
      };
    };

    "requests-futures" = python.mkDerivation {
      name = "requests-futures-0.9.7";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/2c/f0/d9a6d4472286405956dd5ac6279fe932a86151df9816bc35afe601495819/requests-futures-0.9.7.tar.gz"; sha256 = "a9ca2c3480b6fac29ec5de59c146742e2ab2b60f8c68581766094edb52ea7bad"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."requests"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/ross/requests-futures";
        license = "License :: OSI Approved :: Apache Software License";
        description = "Asynchronous Python HTTP for Humans.";
      };
    };

    "responses" = python.mkDerivation {
      name = "responses-0.9.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/67/cb/0a5390f7b8944cfa7e4079a839adba964d858d27a60af7b2683248148339/responses-0.9.0.tar.gz"; sha256 = "c6082710f4abfb60793899ca5f21e7ceb25aabf321560cc0726f8b59006811c9"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."cookies"
      self."coverage"
      self."flake8"
      self."pytest"
      self."pytest-cov"
      self."requests"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/getsentry/responses";
        license = licenses.asl20;
        description = "A utility library for mocking out the `requests` Python library.";
      };
    };

    "s3transfer" = python.mkDerivation {
      name = "s3transfer-0.1.13";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/9a/66/c6a5ae4dbbaf253bd662921b805e4972451a6d214d0dc9fb3300cb642320/s3transfer-0.1.13.tar.gz"; sha256 = "90dc18e028989c609146e241ea153250be451e05ecc0c2832565231dacdf59c1"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."botocore"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/boto/s3transfer";
        license = licenses.asl20;
        description = "An Amazon S3 Transfer Manager";
      };
    };

    "simplegeneric" = python.mkDerivation {
      name = "simplegeneric-0.8.1";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/3d/57/4d9c9e3ae9a255cd4e1106bb57e24056d3d0709fc01b2e3e345898e49d5b/simplegeneric-0.8.1.zip"; sha256 = "dc972e06094b9af5b855b3df4a646395e43d1c9d0d39ed345b7393560d0b9173"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://cheeseshop.python.org/pypi/simplegeneric";
        license = licenses.zpl21;
        description = "Simple generic functions (similar to Python's own len(), pickle.dump(), etc.)";
      };
    };

    "simplejson" = python.mkDerivation {
      name = "simplejson-3.13.2";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/0d/3f/3a16847fe5c010110a8f54dd8fe7b091b4e22922def374fe1cce9c1cb7e9/simplejson-3.13.2.tar.gz"; sha256 = "4c4ecf20e054716cc1e5a81cadc44d3f4027108d8dd0861d8b1e3bd7a32d4f0a"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/simplejson/simplejson";
        license = licenses.mit;
        description = "Simple, fast, extensible JSON encoder/decoder for Python";
      };
    };

    "six" = python.mkDerivation {
      name = "six-1.10.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"; sha256 = "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pypi.python.org/pypi/six/";
        license = licenses.mit;
        description = "Python 2 and 3 compatibility utilities";
      };
    };

    "slugid" = python.mkDerivation {
      name = "slugid-1.0.7";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/dd/96/b05c6d357f8d6932bea2b360537360517d1154b82cc71b8eccb70b28bdde/slugid-1.0.7.tar.gz"; sha256 = "6dab3c7eef0bb423fb54cb7752e0f466ddd0ee495b78b763be60e8a27f69e779"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://taskcluster.github.io/slugid.py";
        license = licenses.mpl20;
        description = "Base64 encoded uuid v4 slugs";
      };
    };

    "structlog" = python.mkDerivation {
      name = "structlog-18.1.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/2a/ba/de51bd39a473d6dc6dd98689d1e31cf2df24d16f7c09911bae895ed27f12/structlog-18.1.0.tar.gz"; sha256 = "ff1e7aae015b346060c03b1cc4a1f29d428de7d858eaf06ea93ee35ac51071a0"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."coverage"
      self."pytest"
      self."simplejson"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.structlog.org/";
        license = licenses.mit;
        description = "Structured Logging for Python";
      };
    };

    "taskcluster" = python.mkDerivation {
      name = "taskcluster-2.1.3";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/9e/c6/a94dc47135d7516f6bf1b877079a08ffa4a420d5be2c39c2fa3d78f28875/taskcluster-2.1.3.tar.gz"; sha256 = "5bc6be5d59bd9a199b445db650081b9a8b7a8f436667172f9623bb34aff97556"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."aiohttp"
      self."async-timeout"
      self."mohawk"
      self."requests"
      self."six"
      self."slugid"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/taskcluster/taskcluster-client.py";
        license = "";
        description = "Python client for Taskcluster";
      };
    };

    "testfixtures" = python.mkDerivation {
      name = "testfixtures-6.0.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/b1/87/1f3e43248af711f09faf05854b4af10a20e9b8c9dc66f500690c5d928bfb/testfixtures-6.0.0.tar.gz"; sha256 = "f6c4cf24d043f9d8e9a9337371ec1d2f6638a0032504bd67dbd724224fd64969"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."coverage"
      self."coveralls"
      self."pytest"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/Simplistix/testfixtures";
        license = licenses.mit;
        description = "A collection of helpers and mock objects for unit tests and doc tests.";
      };
    };

    "tqdm" = python.mkDerivation {
      name = "tqdm-4.20.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/02/b3/8ddd17d1ac31d388f18b69db89a61889b859f6c02aed8425c4495662ea7f/tqdm-4.20.0.tar.gz"; sha256 = "4f2eb1d14804caf7095500fe11da0e481a47af912e7b57c93f886ac3c40a49dd"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/tqdm/tqdm";
        license = licenses.mit;
        description = "Fast, Extensible Progress Meter";
      };
    };

    "traitlets" = python.mkDerivation {
      name = "traitlets-4.3.2";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/a5/98/7f5ef2fe9e9e071813aaf9cb91d1a732e0a68b6c44a32b38cb8e14c3f069/traitlets-4.3.2.tar.gz"; sha256 = "9c4bd2d267b7153df9152698efb1050a5d84982d3384a37b2c1f7723ba3e7835"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."decorator"
      self."ipython-genutils"
      self."pytest"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://ipython.org";
        license = licenses.bsdOriginal;
        description = "Traitlets Python config system";
      };
    };

    "typed-ast" = python.mkDerivation {
      name = "typed-ast-1.1.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/52/cf/2ebc7d282f026e21eed4987e42e10964a077c13cfc168b42f3573a7f178c/typed-ast-1.1.0.tar.gz"; sha256 = "57fe287f0cdd9ceaf69e7b71a2e94a24b5d268b35df251a88fef5cc241bf73aa"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/python/typed_ast";
        license = licenses.asl20;
        description = "a fork of Python 2 and 3 ast modules with type comment support";
      };
    };

    "urllib3" = python.mkDerivation {
      name = "urllib3-1.22";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"; sha256 = "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."certifi"
      self."idna"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://urllib3.readthedocs.io/";
        license = licenses.mit;
        description = "HTTP library with thread-safe connection pooling, file post, and more.";
      };
    };

    "wcwidth" = python.mkDerivation {
      name = "wcwidth-0.1.7";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz"; sha256 = "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/jquast/wcwidth";
        license = licenses.mit;
        description = "Measures number of Terminal column cells of wide-character codes";
      };
    };

    "wmctrl" = python.mkDerivation {
      name = "wmctrl-0.3";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/01/c6/001aefbde5782d6f359af0a8782990c3f4e751e29518fbd59dc8dfc58b18/wmctrl-0.3.tar.gz"; sha256 = "d806f65ac1554366b6e31d29d7be2e8893996c0acbb2824bbf2b1f49cf628a13"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://bitbucket.org/antocuni/wmctrl";
        license = licenses.bsdOriginal;
        description = "A tool to programmatically control windows inside X";
      };
    };

    "yamllint" = python.mkDerivation {
      name = "yamllint-1.11.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/2b/94/0d1fcfe76e2d50bf0b9ab96b2fdd39fa78747757aee4d25829edd5a84664/yamllint-1.11.0.tar.gz"; sha256 = "05cfcaea325f0f0a806b602926e6fb863865d125e69dde3f4b59278dfc5f9684"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."PyYAML"
      self."pathspec"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/adrienverge/yamllint";
        license = licenses.gpl3;
        description = "A linter for YAML files.";
      };
    };

    "yarl" = python.mkDerivation {
      name = "yarl-1.1.1";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/91/14/5983db75b143681058d31a0a89a770f40a7f68f9b94cfeb6e6495b0039bf/yarl-1.1.1.tar.gz"; sha256 = "a69dd7e262cdb265ac7d5e929d55f2f3d07baaadd158c8f19caebf8dde08dfe8"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."idna"
      self."multidict"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/aio-libs/yarl/";
        license = licenses.asl20;
        description = "Yet another URL library";
      };
    };
  };
  localOverridesFile = ./requirements_override.nix;
  overrides = import localOverridesFile { inherit pkgs python; };
  commonOverrides = [
    
  ];
  allOverrides =
    (if (builtins.pathExists localOverridesFile)
     then [overrides] else [] ) ++ commonOverrides;

in python.withPackages
   (fix' (pkgs.lib.fold
            extends
            generated
            allOverrides
         )
   )