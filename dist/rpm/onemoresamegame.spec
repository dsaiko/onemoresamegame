Name:           onemoresamegame
Version:        0.9.10
Release:        1%{?dist}
Summary:        One more version of a puzzle game where you select the same group of pieces

License:        APSL 2.0+
URL:            https://github.com/dsaiko/onemoresamegame
Source0:        https://github.com/dsaiko/onemoresamegame/archive/%{version}.tar.gz#/%{name}-%{version}.tar.gz

BuildRequires:  desktop-file-utils, qt5-qtbase-devel >= 5.2.1, qt5-qtdeclarative-devel 
Requires:       qt5-qtbase >= 5.2.1, qt5-qtdeclarative, qt5-qtquickcontrols, qt5-qtgraphicaleffects

%description
Not enough SameGames out there?
 - I really do not mind playing it
 - and I also want to test QT5 mobile development

%prep
%setup -q

%build
qmake-qt5 CONFIG+=release target.path=/usr/bin
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make install INSTALL_ROOT=$RPM_BUILD_ROOT
mkdir -p %{buildroot}%{_datadir}/pixmaps/
mkdir -p %{buildroot}%{_datadir}/applications/
mkdir -p %{buildroot}%{_datadir}/man/man6/
cp icon.png %{buildroot}%{_datadir}/pixmaps/onemoresamegame.png
cp onemoresamegame.desktop %{buildroot}%{_datadir}/applications/
cp dist/onemoresamegame.6.gz %{buildroot}%{_datadir}/man/man6/

desktop-file-install                                    \
--delete-original                                       \
--dir=%{buildroot}%{_datadir}/applications              \
%{buildroot}%{_datadir}/applications/onemoresamegame.desktop

%files
%{_bindir}/onemoresamegame
%{_datadir}/pixmaps/onemoresamegame.png
%{_datadir}/applications/onemoresamegame.desktop
%{_datadir}/man/man6/onemoresamegame.6.gz

%changelog
* Wed Aug 27 2014 Dusan Saiko <dusan.saiko@gmail.com> 0.9.10-1
- Creating man page
- Creating man page
- Aded Czech and German translation
- Added OS type detection (using Q_OS_* macros only)
- Finalized and optimized images
- Creating development version: 1.0.0-SNAPSHOT

* Wed Aug 27 2014 Dusan Saiko <dusan.saiko@gmail.com> 0.9.9-1
- Finished codebase tuning
- Ending game when only one piece of any color is left
- Added score-sync-in-progress animation
- Creating development version: 0.9.9-SNAPSHOT

* Wed Aug 27 2014 Dusan Saiko <dusan.saiko@gmail.com> 0.9.8-1
- Refactoring source code finished
- Refactoring source code - part 8
- Refactoring source code - part 7
- Refactoring source code - part 6
- Refactoring source code - part 5
- Creating development version: 0.9.8-SNAPSHOT

* Wed Aug 27 2014 Dusan Saiko <dusan.saiko@gmail.com> 0.9.7-1
- Migrated to new DB backend
- Refactoring source code - part 4
- Refactoring source code - part 3
- Refactoring source code - part 2
- Refactoring source code - part 1
- Creating development version: 0.9.7-SNAPSHOT

* Wed Aug 27 2014 Dusan Saiko <dusan.saiko@gmail.com> 0.9.6-1
- Online score sync finished
- Creating development version: 0.9.6-SNAPSHOT

* Wed Aug 27 2014 Dusan Saiko <dusan.saiko@gmail.com> 0.9.5-1
- Creating version 0.9.5
- Deleting local scores on room number change
- Added room number generator and validator
- Finished local scores
- Creating development version: 0.9.5-SNAPSHOT

* Wed Aug 27 2014 Dusan Saiko <dusan.saiko@gmail.com> 0.9.4-1
- Designed score table
- Changing menu panel layout
- Improving build system
- Creating development version: 0.9.3-SNAPSHOT

* Wed Aug 27 2014 Dusan Saiko <dusan.saiko@gmail.com> 0.9.2-1
- Redesigned game start buttons
- Menu buttons layout
- Designing new Menu Panel
- Menu panel buttons.
- Changing images source structure
- Menu button redesign
- Code optimizing
- Introducint post-commit hook to tag version numbers
- Adding GIT version numbering
- Small dist scripts fixes

* Wed Aug 27 2014 Dusan Saiko <dusan.saiko@gmail.com> 0.9.1-1
- Finished RPM packages
- Extending Arch package scripts
- Finished deb packages for debian testing/jessie
- Creating Arch installation scripts
- Creating .deb installation scripts
- Testing deb creation

* Wed Aug 27 2014 Dusan Saiko <dusan.saiko@gmail.com> 0.9-1
- Resizing of game window simplified
- Migrated to QT 5.2.1 to support Ubuntu Trusty

* Wed Aug 27 2014 Dusan Saiko <dusan.saiko@gmail.com> 0.8-1
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

* Wed Aug 27 2014 Dusan Saiko <dusan.saiko@gmail.com> 0.1-1
- Initial commit
- Update README.md
- Update README.md
