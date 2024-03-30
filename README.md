# Docker
Данный docker-образ, содержит актуальные версии 
- samtools + htslib + libdeflate;
- bcftools;
- vcftools.
- Базовый образ – официальная Ubuntu:18.04
- Общие (не специализированные, не биоинформатические) пакеты, программы и библиотеки в
большинстве случаев должны быть установлены с помощью менеджеров пакетов apt, pip и
др.;
- Каждая специализированная программа и библиотека установлена в свою
подпапку в папке $SOFT, в конце имени которой должна быть указана версия (релиз)
- Переменная окружения $SOFT задана как «/soft».

## Информация о зогружаемых специализированных программах
- samtools - 1.19.2
- htslib - 1.19.1
- libdeflate - 1.10 (не самый последний релиз, с 20 версией проблемы какие-то)
- bcftools -1.19
- vcftools -0.1.16

Скрин прилагается:
![Скрин](https://github.com/Albinam1/docker/assets/96633706/be401ef1-528b-4b8e-b7c3-6ba25839cdbf)
