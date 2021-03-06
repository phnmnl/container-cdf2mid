FROM container-registry.phenomenal-h2020.eu/phnmnl/rbase:v3.4.3-1xenial0_cv0.3.17

LABEL maintainer="PhenoMeNal-H2020 Project (phenomenal-h2020-users@googlegroups.com)"
LABEL version="0.3"
LABEL software.version="1.0"
LABEL software="cdf2mid"
LABEL description="Reads CDF files containing multiple mass spectra of 13C-labeled metabolites, and write the extracted spectra in a format exchangeable with Metabilights database."
LABEL website="https://github.com/seliv55/cdf2mid"
LABEL documentation="https://github.com/phnmnl/container-cdf2mid/blob/master/README.md"
LABEL license="https://github.com/phnmnl/container-cdf2mid/blob/master/License.txt"
LABEL tags="Metabolomics"

ENV cdf2mid_REVISION "00d15879b31710b8e8f61402ec6d57acb3274457"

# Setup package repos
RUN apt-get -y update && apt-get -y --no-install-recommends install r-base-dev libssl-dev \
                                    libcurl4-openssl-dev git \
                                    libssh2-1-dev r-cran-ncdf4 && \
    echo 'options("repos"="http://cran.rstudio.com")' >> /etc/R/Rprofile.site && \
    R -e "install.packages(c('devtools', 'optparse'))" && \
    R -e 'library(devtools); install_github("seliv55/cdf2mid",ref=Sys.getenv("cdf2mid_REVISION")[1])' && \
    apt-get purge -y git r-base-dev libssl-dev libcurl4-openssl-dev libssh2-1-dev && \
    apt-get clean && apt-get autoremove -y && rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*

# Add scripts folder to container
ADD scripts/runcdf2mid.R /usr/bin/runcdf2mid.R
RUN chmod +x /usr/bin/runcdf2mid.R

# Add test scripts
ADD runTest1.sh /usr/local/bin/runTest1.sh
RUN chmod a+x /usr/local/bin/runTest1.sh
# Define Entry point script
ENTRYPOINT ["runcdf2mid.R"]
