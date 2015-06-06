Name:           fusor_ovirt
Version:        0.1
Release:        1%{?dist}
Summary:        Scripts to interact with oVirt API

Group:          Applications/System
License:        GPLV3+ and ASL 2.0
URL:            https://github.com/fusor/fusor_ovirt
Source0:        %{name}-%{version}.tar.gz

Requires:       ovirt-engine-sdk-python

%description
Python scripts to interact with the oVirt API

%prep
%setup -q


%build

%install
install -d -m0755 %{buildroot}%{_datadir}/%{name}/bin
install -d -m0755 %{buildroot}%{_datadir}/%{name}/example
cp bin/*.py %{buildroot}%{_datadir}/%{name}/bin
cp example/* %{buildroot}%{_datadir}/%{name}/example

%files
%defattr(755,root,root,-)
%{_datadir}/%{name}/bin
%{_datadir}/%{name}/example
%doc



%changelog
* Mon Jun 01 2015 John Matthews <jwmatthews@gmail.com> 0.0.1-1
- Initial packaging


