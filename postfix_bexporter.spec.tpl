Name:           postfix_bexporter
Version:        __VERSION__
Release:        1%{?dist}
Summary:        A reinvented Postfix metrics exporter

License:        MIT
URL:            https://0123e.ru/postfix_bexporter
Source0:        __SOURCE_TARGZ_FILENAME__

BuildRequires:  
Requires:       

%description
postfix_bexporter is a Prometheus metrics exporter,
written in Bash. Supposed to be small and with very
limited functionality.

%prep
%setup -q


%build
%configure
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
%make_install


%files
/opt/postfix_bexporter/postfix_bexporter.sh
/opt/postfix_bexporter/README.md
%doc



%changelog
__CHANGELOG__