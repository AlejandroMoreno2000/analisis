# Herramienta de análisis y clasificación

Este repositorio contiene los recursos necesarios para ejecutar y reproducir el sistema de clasificación de malware y goodware basado en trazas electromagnéticas, desarrollado en el contexto del segundo experimento de este Trabajo de Fin de Grado (TFG). Dicho experimento ha proporcionado los resultados más satisfactorios del estudio.

El proyecto se basa en el código original publicado por el equipo de investigación de **Duy-Phuc Pham et al.** ([repositorio original](https://github.com/ahma-hub/analysis)) y presenta:
- Un nuevo conjunto de datos EM recogido en condiciones físicas diferentes.
- Modelos entrenados sobre dicho conjunto.
- Scripts modificados para permitir tanto la evaluación como el entrenamiento personalizado de modelos.

## Descarga de recursos

Todos los archivos necesarios para ejecutar los scripts están disponibles en el siguiente enlace:
```
https://mega.nz/folder/PU5xXL5Z#mO2JnmCy7AjDGe-2PYiqJw
```

Contenido:
- traces_reduced_dataset.7z: Trazas EM ya segmentadas y listas para reproducir resultados.
- raw_dataset.7z: Dataset completo en crudo para procesamiento desde cero.
- list_selected_badwidth.7z: Índices y etiquetas de trazas EM procesadas con bandas seleccionadas.
- lists_reduced_dataset.7z: Índices y etiquetas de trazas EM sin procesar (previas al filtrado de bandas).
- acc_stft_reduced_dataset.7z: Acumuladores precomputados necesarios para aplicar STFT.

## Repositorio de muestras

Las trazas electromagnéticas utilizadas por este sistema fueron generadas a partir de los binarios incluidos en el siguiente repositorio:

🔗 [Repositorio de muestras de malware y goodware](https://github.com/AlejandroMoreno2000/dataset/)

Este conjunto está estructurado y etiquetado para alinearse con los esquemas de clasificación implementados en esta herramienta.

## Requisitos

- Python 3.6 o superior.
- Instalar dependencias con:
```
pip install -r requirements.txt
```

## Entrenamiento de nuevos modelos (desde trazas no procesadas)

Este flujo permite usar trazas sin preprocesar y entrenar modelos personalizados.

```
# Formato general
./update_lists.sh [dir. list_reduced_badwidth] [dir. raw_dataset]
./run_dl_on_selected_bandwidth.sh 
./run_ml_on_selected_bandwidth.sh [dir. list_reduced_badwidth] [dir. acc_stft_reduced_dataset] [modelo CNN o MLP {cnn, mlp}] [nº épocas] [tamaño del batch]
```

```
# Ejemplo
./update_lists.sh ./lists_reduced_dataset/ ./traces_selected/

# Entrenar modelos de ML (SVM, NB, LDA)
./run_ml_on_reduced_dataset.sh

# Entrenar modelos de DL (CNN o MLP)
./run_dl_on_reduced_dataset.sh ./lists_reduced_dataset/ ./acc_stft_reduced_dataset/ cnn 100 100
```

Los modelos entrenados se guardarán como .jl (ML) o .h5 (DL).

> **Nota:** El conjunto de trazas EM en crudo es una versión reducida del total capturado. Por limitaciones de almacenamiento, no ha sido posible incluir el dataset completo (~200 GB). Esto puede afectar la capacidad de generalización y precisión de los modelos entrenados.

## Evaluación con modelos preentrenados 

Este flujo utiliza trazas ya transformadas (STFT + selección de bandas relevantes), y permite validar modelos preentrenados incluidos en el repositorio.

> **Importante:** Los modelos preentrenados de Deep Learning (CNN y MLP) se encuentran comprimidos por defecto.  
> Antes de utilizarlos, es necesario descomprimirlos utilizando el ejecutable `decompress` incluido en cada directorio (`dl_analysis/pretrained_models/CNN` y `.../MLP`).  

```
# Formato general
./update_lists.sh [dir. list_selected_badwidth] [dir. traces_reduced_dataset]
./run_dl_on_selected_bandwidth.sh [dir. lists_selected_bandwidth] [dir. pretrained_models] [dir. acc_dataset]
./run_ml_on_selected_bandwidth.sh [dir. lists_selected_bandwidth] [dir. pretrained_models] [dir. acc_dataset]
```

```
# Ejemplo
./update_lists.sh ./lists_selected_bandwidth/ ./traces_40bd_reduced_dataset/

# Evaluar modelos de Machine Learning
./run_ml_on_selected_bandwidth.sh ./lists_selected_bandwidth/ ./pretrained_models/ ./acc_raw_reduced_dataset/

# Evaluar modelos de Deep Learning (CNN / MLP)
./run_dl_on_selected_bandwidth.sh ./lists_selected_bandwidth/ ./pretrained_models/ ./acc_stft_reduced_dataset/
```

## Resultados

Los resultados generados por los modelos se almacenan automáticamente en archivos de log, **diferenciados según el conjunto de datos empleado** (dataset reducido o dataset con bandas seleccionadas):

- Para modelos de **Machine Learning** (SVM, Naïve Bayes):
  - `ml_analysis/log-evaluation_reduced_dataset.txt`: resultados obtenidos a partir del dataset reducido (trazas sin transformar).
  - `ml_analysis/log-evaluation_selected_bandwidth.txt`: resultados correspondientes al dataset con bandas seleccionadas (tras aplicar STFT y filtrado).

- Para modelos de **Deep Learning** (CNN / MLP):
  - `dl_analysis/training_log_reduced_dataset_{cnn,mlp}.txt`: métricas de validación durante el entrenamiento sobre el dataset reducido.
  - `dl_analysis/evaluation_log_DL.txt`: resultados de evaluación sobre el dataset con bandas seleccionadas, utilizando modelos preentrenados.
