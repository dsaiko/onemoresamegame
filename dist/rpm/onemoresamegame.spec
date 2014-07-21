Name:           onemoresamegame
Version:        0.9
Release:        1%{?dist}
Summary:        One more version of a puzzle game where you select the same group of pieces

License:        Apache License, Version 2.0
URL:            https://github.com/dsaiko/onemoresamegame
Source0:        onemoresamegame-%{version}.tar.gz

BuildRequires:  desktop-file-utils, qt5-qtbase-devel >= 5.2.1, qt5-qtdeclarative-devel 
Requires:       qt5-qtbase >= 5.2.1, qt5-qtdeclarative, qt5-qtquickcontrols

%description
Not enought SameGames out there?
 - I really do not mind playing it
 - and I also want to test QT5 mobile development

%prep
%setup -q

%build
qmake-qt5 CONFIG+=release
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make install INSTALL_ROOT=$RPM_BUILD_ROOT
mkdir -p %{buildroot}%{_datadir}/pixmaps/
mkdir -p %{buildroot}%{_datadir}/applications/
cp icon.png %{buildroot}%{_datadir}/pixmaps/onemoresamegame.png
cp dist/rpm/onemoresamegame.desktop %{buildroot}%{_datadir}/applications/

desktop-file-install                                    \
--delete-original                                       \
--dir=%{buildroot}%{_datadir}/applications              \
%{buildroot}%{_datadir}/applications/onemoresamegame.desktop

%files
%{_bindir}/onemoresamegame
%{_datadir}/pixmaps/onemoresamegame.png
%{_datadir}/applications/onemoresamegame.desktop

%changelog
* Mon Jul 21 2014 Dusan Saiko <dusan.saiko@gmail.com> 0.9
- Resizing of game window simplified
- Migrated to QT 5.2.1 to support Ubuntu Trusty

* Mon Jul 21 2014 Dusan Saiko <dusan.saiko@gmail.com> 0.8
- Finishing levels
- new icon
- Finishing levels and multiple size
- major refactoring and GUI change
- bugfixes
- Code optimization
- Creating app icon
- Licence change do ASL2.0
- Improving code
- Adding platform dependent behaviour for onClick/onMouseEntered for mobile platforms without mouse cursor.
- Adding falling of pieces
- Finishing pop-up effects
- Finetuning image smoothing
- Renaming to One More SameGame

* Mon Jul 21 2014 Dusan Saiko <dusan.saiko@gmail.com> 0.1
- Initial commit
- Update README.md
- Update README.md
