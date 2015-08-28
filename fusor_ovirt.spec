Name:           fusor_ovirt
Version:        0.1
Release:        1%{?dist}
Summary:        Scripts to interact with oVirt API

Group:          Applications/System
License:        GPLV3+ and ASL 2.0
URL:            https://github.com/fusor/fusor_ovirt
Source0:        %{name}-%{version}.tar.gz

Requires:       ovirt-engine-sdk-python
Requires:       python-paramiko
Requires:       python-crypto
Requires:       python-ecdsa

%description
Python scripts to interact with the oVirt API

%prep
%setup -q


%build

%install
install -d -m0755 %{buildroot}%{_datadir}/%{name}/bin
cp bin/*.{py,rb} %{buildroot}%{_datadir}/%{name}/bin

%files
%defattr(755,root,root,-)
%{_datadir}/%{name}/bin
%doc



%changelog
* Mon Jun 01 2015 John Matthews <jwmatthews@gmail.com> 0.0.1-1
- Initial packaging


