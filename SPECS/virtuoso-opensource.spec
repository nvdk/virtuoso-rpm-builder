Summary: Virtuoso is an opensource RDF Store
Name: virtuoso-opensource
Version: ##VERSION##
Release: tf
License: GPL-2
Group: Application/Semantics
URL: http://github.com/openlink/virtuoso-opensource/
Source0: %{name}-%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
BuildRequires: gcc autoconf automake libtool flex bison gawk m4 make
BuildRequires: openssl-devel readline-devel readline
Requires: openssl redhat-lsb
 
%description
Virtuoso is a scalable cross-platform server that combines Relational, Graph and Document Data Management with Web Application Server and Web Services Platform functionality.
%prep
 
%setup -q 
 
%build
CFLAGS="-O2 -m64";export CFLAGS
./autogen.sh
./configure --prefix=/usr --localstatedir=/var --disable-bpel-vad --enable-conductor-vad --disable-dbpedia-vad --disable-demo-vad --disable-isparql-vad --disable-ods-vad --disable-sparqldemo-vad --disable-syncml-vad --disable-tutorial-vad --sysconfdir=/etc --with-readline --program-transform-name="s/isql/isql-v/"
make
 
%install
make install DESTDIR=%{buildroot}
mkdir -p %{buildroot}/{etc/init.d/,var/log/virtuoso,etc/logrotate.d}
cp tf-addons/virtuoso.init  "%{buildroot}/etc/init.d/virtuoso-opensource"
cp tf-addons/virtuoso.logrotate "%{buildroot}/etc/logrotate.d/virtuoso"
sed -i 's/\/var\/lib\/virtuoso\/db\/virtuoso.log/\/var\/log\/virtuoso\/database.log/' %{buildroot}/var/lib/virtuoso/db/virtuoso.ini

# generate file list (cfr http://www.techrepublic.com/article/making-rpms-part-4-finishing-the-spec-file/)
find %{buildroot} -type f > $RPM_BUILD_DIR/file.list.%{name}
sed -i 's|%{buildroot}| |' $RPM_BUILD_DIR/file.list.%{name}
echo "-- FILE LIST -- "
cat $RPM_BUILD_DIR/file.list.%{name}

%post
/sbin/chkconfig virtuoso-opensource on
 
%clean
rm -rf %{buildroot}

%files -f ../file.list.%{name}
%dir /var/log/virtuoso
%defattr(-,root,root,-)
%docdir /usr/share/virtuoso/doc
 
%changelog
* ##DATE## TenforceBuilder <support@tenforce.com>
- Automated build of %{version}
