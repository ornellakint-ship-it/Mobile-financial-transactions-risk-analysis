

#  Detection of Suspicious Patterns in Mobile Financial Transactions

> **📌 Note:** A **French version of this README is available below**.
> Scroll down to read **🇫🇷 Version française**.

---

## Project Overview

This project explores **mobile-based financial transaction data** to identify **atypical transactional behaviors** that may indicate potential fraud risks.

The objective is to provide a **business-oriented exploratory analysis**, relying on **simple, interpretable rules** aligned with **operational practices in the telecommunications and fintech industries**.

The analysis was conducted using:

* **MySQL** for data preparation, cleaning, and consistency checks
* **Power BI** for data modeling, DAX calculations, and interactive visualizations

---

##  Methodology

Four key **risk signals** were analyzed:

1. **Abnormally high transaction frequency** within a 24-hour window
2. **High-value transactions executed at night** (00:00–05:00)
3. **Use of multiple devices by a single subscriber**
4. **Atypical transaction amounts (outliers)**

###  Statistical Threshold for Outliers

To detect unusually large transactions, a **three standard deviations (3σ)** threshold was applied:

> **Suspicious threshold = mean + 3 × standard deviation**

This approach helps identify **extreme values** while limiting **false positives**, a critical challenge in mobile financial transaction monitoring systems.

---

##  Key Insights

### Global Overview

* **6,400+ transactions** analyzed, representing a total value of **18 million**
* **38% of subscribers** exhibit at least one risk signal
* The **agent channel** dominates both transaction volume and total value

---

### Indicator 1 — High Transaction Frequency

* **212 subscribers** perform more than **20 transactions within 24 hours**
* This represents **14.36%** of the customer base
* A small group shows **transaction volumes significantly above normal levels**

---

### Indicator 2 — High-Value Night Transactions

* **35 high-value transactions** detected during night hours
* These represent only **2.16% of night transactions**, yet account for **≈ 430,000** in value
* Most of these transactions occur through the **agent channel**

---

### Indicator 3 — Multiple Device Usage

* **393 subscribers** use **more than 5 different devices**
* This corresponds to **26.63% of the customer base**
* Such behavior may indicate **account sharing or potential identity misuse**

---

### Indicator 4 — Atypical Amounts (Outliers)

* Transactions exceeding the statistical threshold (**≈ 9,222**) are rare
* Despite their low frequency, they represent **high financial risk exposure**

---

## Limitations & False Positives

Transactions or subscribers flagged as suspicious are **not necessarily fraudulent**.

Examples include:

* High-value night transactions linked to **emergency medical expenses**
* High-frequency activity reflecting **legitimate commercial operations**

These indicators should therefore be treated as **alerts**, requiring:

* Deeper behavioral analysis
* Additional data (customer profile, long-term history, geolocation, KYC information)

---

## Operational Recommendations

* Implement **enhanced monitoring** for high-value night transactions
* **Combine multiple risk signals** (frequency + device usage + amount) to reduce false positives
* Prioritize monitoring efforts on **channels with higher operational risk**
* Consider **advanced approaches** (risk scoring, machine learning models) for more precise detection

---

## Personal Learnings

Through this project, I:

* Strengthened my **Power BI skills** (DAX, data modeling, KPIs, storytelling)
* Gained practical insight into **real-world fraud risks** in mobile financial systems
* Learned to balance **risk detection and false-positive reduction**
* Designed dashboards usable by **non-technical stakeholders**

---

## Tools & Skills

* SQL (MySQL)
* Power BI & DAX
* Exploratory Data Analysis
* Transactional Risk Detection
* Telecom & Fintech-oriented Data Storytelling

---

---

# 🇫🇷 Détection de comportements suspects dans des transactions financières mobiles

## Présentation du projet

Ce projet analyse des données de **transactions financières réalisées via téléphone mobile** afin d’identifier des **comportements transactionnels atypiques** pouvant indiquer des risques potentiels de fraude.

L’objectif est de proposer une **analyse exploratoire orientée métier**, basée sur des **règles simples, interprétables**, proches des pratiques opérationnelles dans les secteurs des **télécommunications et de la fintech**.

Les analyses ont été réalisées avec :

* **MySQL** (préparation, nettoyage et contrôles de cohérence)
* **Power BI** (modélisation, DAX et visualisation)

---

##  Méthodologie

Quatre signaux de risque ont été étudiés :

* Fréquence anormalement élevée de transactions sur 24h
* Transactions de montants élevés réalisées durant la nuit (00h–05h)
* Utilisation de plusieurs appareils par un même abonné
* Montants atypiques (outliers)

### Calcul du seuil de transactions suspectes

Un seuil statistique basé sur **trois écarts-types (3σ)** a été utilisé :

> **Seuil suspect = moyenne + 3 × écart-type**

Cette méthode permet d’identifier des montants extrêmes tout en **limitant les faux positifs**, un enjeu clé dans les systèmes de paiement mobile.

---

##  Insights clés

###  Vue globale

* **6 400+ transactions** analysées pour un volume total de **18 millions**
* **38 % des abonnés** présentent au moins un signal de risque
* Le **canal agent** concentre la majorité des transactions, en volume comme en valeur

###  Indicateur 1 — Fréquence élevée de transactions

* **212 abonnés** effectuent plus de **20 transactions en 24h**
* Ils représentent **14,36 %** de la base clients
* Une minorité présente une activité nettement supérieure à la normale

###  Indicateur 2 — Transactions importantes réalisées la nuit

* **35 transactions nocturnes à montant élevé**
* Elles représentent **2,16 %** des transactions nocturnes mais **≈ 430 000** en valeur
* Majoritairement observées via le **canal agent**

###  Indicateur 3 — Utilisation de plusieurs appareils

* **393 abonnés** utilisent plus de **5 appareils**
* Soit **26,63 %** de la base clients
* Peut indiquer un **partage de compte ou une usurpation**

###  Indicateur 4 — Montants atypiques (outliers)

* Les transactions au-dessus du seuil (**≈ 9 222**) sont rares
* Elles concentrent néanmoins un **risque financier élevé**

---

##  Limites et faux positifs

Les abonnés ou transactions signalés comme suspects ne sont **pas nécessairement frauduleux**.

Exemples :

* Paiement nocturne élevé lié à des **soins médicaux d’urgence**
* Fréquence élevée liée à une **activité commerciale légitime**

Ces signaux doivent être considérés comme des **alertes**, nécessitant :

* Une analyse comportementale approfondie
* Des données complémentaires (profil client, historique long terme, géolocalisation, KYC)

---

##  Recommandations opérationnelles

* Renforcer la surveillance des **transactions nocturnes à fort montant**
* Combiner plusieurs signaux pour **réduire les faux positifs**
* Prioriser les canaux à **risque opérationnel élevé**
* Envisager des approches avancées (scoring, machine learning)

---

## Apprentissages personnels

Ce projet m’a permis de :

* Renforcer fortement mes compétences en **Power BI** (DAX, KPI, storytelling)
* Comprendre les enjeux métier réels de la fraude transactionnelle
* Apprendre à équilibrer **détection du risque et limitation des faux positifs**
* Concevoir des tableaux de bord exploitables par des équipes non techniques

---

## Outils & compétences

* SQL (MySQL)
* Power BI & DAX
* Analyse exploratoire de données
* Détection de risques transactionnels
* Data storytelling orienté télécom / fintech




