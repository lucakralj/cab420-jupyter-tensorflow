FROM tensorflow/tensorflow:2.14.0-gpu-jupyter

RUN apt-get update --yes && \
    apt-get upgrade --yes && \
    apt install --yes --no-install-recommends python3-pip git wget curl bash libgl1 software-properties-common openssh-server nginx libcublas-12-0  && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen

RUN mkdir -p /workspace && \
    cd /workspace && \
    git clone https://bitbucket.org/simondenman/cab420_examples.git

RUN pip install --upgrade --no-cache-dir jupyterlab ipywidgets jupyter-archive jupyter_contrib_nbextensions tensorflow[and-cuda] keras matplotlib seaborn scikit-learn scikit-image statsmodels opencv-python pandas gensim pillow tensorflow-datasets xgboost jupyter ipython pydot pydot-ng graphviz pandoc
RUN pip install notebook==6.5.5
RUN jupyter contrib nbextension install --user && \
    jupyter nbextension enable --py widgetsnbextension

WORKDIR /workspace

COPY /proxy/nginx.conf /etc/nginx/nginx.conf

COPY scripts/ /scripts/
RUN chmod +x /scripts/*.sh

ENTRYPOINT ["/scripts/start.sh"]
