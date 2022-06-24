PORTNAME=	skia
DISTVERSION=	g20220619
CATEGORIES=	graphics
PKGNAMESUFFIX=	-dev
DISTNAME=	${PORTNAME}-${GH_TAGNAME}
DIST_SUBDIR=	${PORTNAME}${PKGNAMESUFFIX}

MAINTAINER=	nope@nothere
COMMENT=	Complete 2D graphic library for drawing Text, Geometries, and Images

LICENSE=	BSD3CLAUSE

BUILD_DEPENDS=	${PYTHON_PKGNAMEPREFIX}Jinja2>=0:devel/py-Jinja2@${PY_FLAVOR} \
		gn:devel/gn \
		ninja:devel/ninja

USES=		ninja:make pkgconfig:build \
		compiler:c++17-lang python:3.7+

BINARY_ALIAS=	python3=${PYTHON_CMD}
MAKE_ARGS=      -C out/Release
USE_LDCONFIG=	yes
CXXFLAGS=	"-I/usr/include/zlib.h"
GN_ARGS+=	is_official_build=true \
		skia_gl_standard="gl" \
		skia_use_dng_sdk=false \
		skia_use_system_zlib=true \
		skia_use_libpng=false \
		skia_use_zlib=false \
		skia_use_libjpeg_turbo=false \
		skia_use_harfbuzz=false \
		skia_use_libwebp=false \
		skia_use_expat=false
# Find how to tell it where zlib is or to somehow replace thirdparty stuff with system things
#		skia_use_system_zlib=true
# ninja: error: '../../third_party/externals/zlib/google/compression_utils_portable.cc', 
# needed by 'obj/third_party/externals/zlib/google/libcompression_utils_portable.compression_utils_portable.o', missing and no known rule to make it
USE_GITHUB=	nodefault
GH_ACCOUNT=	google
GH_PROJECT=	skia
GH_TAGNAME=	9e568b3f646411fdb2986a9f7eab1b10ed42b525

WRKSRC=		${WRKDIR}/${PORTNAME}-${GH_TAGNAME}

CONFIGURE_ENV+= NINJAFLAGS="-j${MAKE_JOBS_NUMBER}" \
		NINJA_PATH="${LOCALBASE}/bin/ninja"  \
		PATH=${CONFIGURE_WRKSRC}/bin:${LOCALBASE}/bin:${PATH}

pre-configure:
	@cd ${WRKSRC}
	@${MKDIR} ${WRKSRC}/out/Release/gen/include

do-configure:
	@cd ${WRKSRC} && ${SETENV} ${CONFIGURE_ENV} gn gen ${WRKSRC}/out/Release --args='${GN_ARGS}'

# check lang/v8
#pre-build:
#		@cd ${WRKSRC}
#		@${EXEC} ${LOCALBASE}/bin/gn gen ${WRKSRC}
#		${TOUCH} ${WRKSRC}/BUILD.gn
#
#MAKE_ARGS=      -C out/${BUILDTYPE}
#MAKE_ENV+=	 CC="${CC}" CXX="${CXX}"		 \
#		 C_INCLUDE_PATH=${LOCALBASE}/include	 \
#		 CPLUS_INCLUDE_PATH=${LOCALBASE}/include \
#		 ${CONFIGURE_ENV}

#LDFLAGS_i386=	-Wl,-znotext

#PORTDATA=	*
#PORTDOCS=	*
# Check lang/v8-beta
#post-patch:
#	 @${REINPLACE_CMD} 's|%%LOCALBASE%%|${LOCALBASE}|' \
#		 ${WRKSRC}/core/Common/3dParty/icu/icu.pri \
#		 ${WRKSRC}/core/DesktopEditor/fontengine/ApplicationFonts.cpp
#	 @${REINPLACE_CMD} -e 's|%%CC%%|${CC}|' -e 's|%%CXX%%|${CXX}|' \
#		 ${WRKSRC}/core/Common/base.pri
#	 @${REINPLACE_CMD} 's|%%WRKDIR%%|${WRKDIR}|' \
#		 ${WRKSRC}/document-server-package/Makefile
#	 @${REINPLACE_CMD} 's|%%WRKSRC%%|${WRKSRC}|' \
#		 ${WRKSRC}/build_tools/scripts/build_js.py \
#		 ${WRKSRC}/build_tools/scripts/build_server.py \
#		 ${WRKSRC}/document-server-package/Makefile
#	 @${REINPLACE_CMD} -e 's|linux|freebsd|' -e 's|/etc|${LOCALBASE}/etc|' \
#		 ${WRKSRC}/document-server-package/common/documentserver/supervisor/ds-docservice.conf.m4 \
#		 ${WRKSRC}/document-server-package/common/documentserver/supervisor/ds-converter.conf.m4 \
#		 ${WRKSRC}/document-server-package/common/documentserver-example/supervisor/ds-example.conf.m4 \
#		 ${WRKSRC}/document-server-package/common/documentserver/bin/documentserver-static-gzip.sh.m4 \
#		 ${WRKSRC}/document-server-package/common/documentserver/bin/documentserver-update-securelink.sh.m4
#	 @${REINPLACE_CMD} 's|/var/www|${LOCALBASE}/www|' \
#		 ${WRKSRC}/document-server-package/common/documentserver/bin/documentserver-generate-allfonts.sh.m4 \
#		 ${WRKSRC}/document-server-package/common/documentserver/bin/documentserver-static-gzip.sh.m4 \
#		 ${WRKSRC}/document-server-package/common/documentserver/supervisor/ds-converter.conf.m4 \
#		 ${WRKSRC}/document-server-package/common/documentserver/supervisor/ds-docservice.conf.m4 \
#		 ${WRKSRC}/document-server-package/common/documentserver/supervisor/ds-metrics.conf.m4
#	 @${REINPLACE_CMD} -e 's|/var/lib|/var/db|' -e 's|/var/www|${LOCALBASE}/www|' \
#			   -e 's|/usr/share|${LOCALBASE}/share|' -e 's|/etc|${LOCALBASE}/etc|' \
#		 ${WRKSRC}/server/Common/config/production-freebsd.json \
#		 ${WRKSRC}/server/Common/config/development-freebsd.json
#	 @${REINPLACE_CMD} -e 's|bash|sh|' -e 's|sed|gsed|' \
#		 ${WRKSRC}/document-server-package/common/documentserver/bin/documentserver-static-gzip.sh.m4 \
#		 ${WRKSRC}/document-server-package/common/documentserver/bin/documentserver-update-securelink.sh.m4
#	 @${REINPLACE_CMD} 's|%%DISTDIR%%|${DISTDIR}|' \
#		 ${WRKSRC}/web-apps/build/patches/optipng-bin+5.1.0.patch
#	 @${REINPLACE_CMD} -e 's|%%LOCALBASE%%|${LOCALBASE}|' -e 's|%%ETCDIR%%|${ETCDIR}|' \
#		 ${WRKSRC}/document-server-package/Makefile
#	 @${RM} ${WRKSRC}/web-apps/build/patches/optipng-bin+5.1.0.patch.orig
#
#	 @${FIND} ${WRKSRC}/server -type f -name npm-shrinkwrap.json -delete
#
#do-build:
#	 @${CP} ${FILESDIR}/packagejsons/server/package-lock.json ${WRKSRC}/server
#	 @${CP} ${FILESDIR}/packagejsons/server/Common/package-lock.json ${WRKSRC}/server/Common
#
#	 @cd ${WRKSRC}/web-apps/build ; ${SETENV} ${MAKE_ENV} npm install patch-package
#	 @cd ${WRKSRC}/web-apps/build ; ${SETENV} ${MAKE_ENV} npm install optipng-bin@5.1.0
#	 @cd ${WRKSRC}/web-apps/build ; node_modules/.bin/patch-package
#	 @cd ${WRKSRC}/web-apps/build/node_modules/optipng-bin ; ${SETENV} ${MAKE_ENV} npm run postinstall optipng-bin

.include <bsd.port.options.mk>

.include <bsd.port.mk>
