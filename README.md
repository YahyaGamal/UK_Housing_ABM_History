# UK housing ABM development history
This repository includes all the developed and internally presented versions of the housing ABM in NetLogo format. Versions 18.x.x are ones developed without a representation of aging (last version 18.4.2 is [published in JASSS](http://jasss.soc.surrey.ac.uk/27/4/5.html)). Versions 19.x.x are ones including a representation of aging, wealth and inheritance.

A collated PowerPoint presentation with all the experiments is available in [this link](https://gla-my.sharepoint.com/:p:/g/personal/yahya_gamalaldin_glasgow_ac_uk/ES__WoB4xOBBrj-_c5VKFwEBWjYhBKQ4FFo9mF99Tm5jDQ?e=Lm7Amz). The presentation is ordered based on the model version used for each experiment, rather than the date at which the results were presented. Each section also refers to the date and the label of the presentation file (shared locally with the involved team members) where the results and the model updates are available.

## List of experiments
The experiments applied for each version are as follows.
1. Version [17.9](https://github.com/YahyaGamal/UK_Housing_ABM_History/blob/main/NetLogo/Housing_Market_Model_17.9.nlogo)
    - Sensitivity to LTV, stamp duty, number of investors, number of remain tenants
    - Interest rate shock at year 50
    - LTV shock at year 50
2. Version [18.0](https://github.com/YahyaGamal/UK_Housing_ABM_History/blob/main/NetLogo/Housing_Market_Model_18.0.nlogo)
    - Interest rate shock at year 50
    - LTV shock at year 50
3. Version [18.1](https://github.com/YahyaGamal/UK_Housing_ABM_History/blob/main/NetLogo/Housing_Market_Model_18.1.nlogo)/[18.2](https://github.com/YahyaGamal/UK_Housing_ABM_History/blob/main/NetLogo/Housing_Market_Model_18.2.nlogo)/[18.3](https://github.com/YahyaGamal/UK_Housing_ABM_History/blob/main/NetLogo/Housing_Market_Model_18.3.nlogo)/[18.3a](https://github.com/YahyaGamal/UK_Housing_ABM_History/blob/main/NetLogo/Housing_Market_Model_18.3a.nlogo)
    - LTV shock at year 100 (95 to 100)
    - LTV shock at year 100 (95 to 85)
4. Version [18.4.1](https://github.com/YahyaGamal/UK_Housing_ABM_History/blob/main/NetLogo/Housing_Market_Model_18.4.1.nlogo)
    - Part 1
        - Baseline (Interest 3.7 and LTV 74)
        - Interest (3.7 to 8 and 8 to 3.7)
        - LTV shock at year 100 (74 to 69 and 69 to 74)
    - Part 2
        - Baseline (Interest 3.7 and LTV 74)
        - Interest (3.7 to 8 and 8 to 3.7)
        - LTV shock at year 100 (74 to 69 and 69 to 74)
        - Grid size (30x30, 64x64 and 100x100)
        - Pattern Oriented Modelling (Interest and LTV)
    - Part 3
        - Extend experiments beyond 180 years (model stability)
        - Sensitivity analysis (income and investors)
        - Spatial hotspot analysis (Getis-Ord)
5. Version [18.4.2](https://github.com/YahyaGamal/UK_Housing_ABM_History/blob/main/NetLogo/Housing_Market_Model_18.4.2.nlogo)
    - Part 1
        - Model stability at different ratios of investors
        - Impact of financial shocks on overall wealth in the system
        - Sensitivity analysis in new stability dynamics (income and investors)
    - Part 2
        - Model stability at different ratios of investors (with cooldown process added)
        - Financial shocks at 20% propensity to invest
        - Sensitivity analysis in new stability dynamics (income and investors’ propensity)
    - Part 3
        - Final sensitivity analysis (LTV, interest, income, propensity to invest)
6. Version [19.0.3](https://github.com/YahyaGamal/UK_Housing_ABM_History/blob/main/NetLogo/Housing_Market_Model_19.0.3.nlogo)
    - Part 1
        - Baseline (rent-to-repayment 120%, first-time buyers 50%)
        - Sudden increase in LTV for first-time buyers to 99%
        - Include 40-year mortgages for first-time buyers
        - Change rent-to-repayment between 120% and 160%
        - Scrap stamp duty for highest tiers and for all tiers
    - Part 2
        - Different ratios of first-time buyers
            - Increase LTV for first-time buyers
            - Include 40-year mortgages for first-time buyers 
        - Increase construction rate and increase LTV for first-time buyers
7. Version [19.0.6](https://github.com/YahyaGamal/UK_Housing_ABM_History/blob/main/NetLogo/Housing_Market_Model_19.0.6.nlogo)
    - Wealth distribution at different income initial distribution
        - Mean income = £10,000
        - Mean income = £20,000
        - Mean income = £30,000
    - Inheritance tax applied after 100 years
8. Version [19.0.7](https://github.com/YahyaGamal/UK_Housing_ABM_History/blob/main/NetLogo/Housing_Market_Model_19.0.7.nlogo)
    - Wealth distribution with different income initial distribution
        - Mean income = £10,000
        - Mean income = £30,000
    - Inheritance tax applied after 150 years
    - Increase prices within a radius around a selected patch (gentrification)
9. Version [19.0.8](https://github.com/YahyaGamal/UK_Housing_ABM_History/blob/main/NetLogo/Housing_Market_Model_19.0.8.nlogo)
    - Wealth distribution with different income initial distribution (histograms)
        - Mean income = £20,000
        - Mean income = £40,000
10. Version [19.0.9](https://github.com/YahyaGamal/UK_Housing_ABM_History/blob/main/NetLogo/Housing_Market_Model_19.0.9.nlogo)
    - Effect of investors on ratios of houses by tenancy types (investors 20% and 80%)
    - Force house ratios by tenancy type (instead of ratios as a result of market dynamics)
    - Income effect on wealth based on age and number of owned houses
11. Version [19.0.10](https://github.com/YahyaGamal/UK_Housing_ABM_History/blob/main/NetLogo/Housing_Market_Model_19.0.10.nlogo)
    - Effect of a sudden increase in interest rates on wealth
12. Version [19.0.12](https://github.com/YahyaGamal/UK_Housing_ABM_History/blob/main/NetLogo/Housing_Market_Model_19.0.12.nlogo)
    - Sensitivity to the number of constructed social houses
    - Thatcher’s 1980 right-to-buy policy
    - Interest financial shock from 3.7% to 8% with social housing
    - LTV financial shock from 90% to 60% with social housing
13. Version [19.0.14](https://github.com/YahyaGamal/UK_Housing_ABM_History/blob/main/NetLogo/Housing_Market_Model_19.0.14.nlogo)
    - Part 1
        - Sensitivity to the number of constructed social houses
        - Temporal scale of ticks (quarterly, monthly and weekly)
        - Thatcher’s 1980 right-to-buy policy
        - Interest financial shock from 3.7% to 8% with social housing
        - LTV financial shock from 90% to 60% with social housing
    - Part 2
        - Baseline at different temporal scale of ticks (quarterly, monthly and weekly)
            - From year 0 to 400
            - From year 295 to 315 
        - Interest financial shock from 3.7% to 8% at different temporal scale of ticks
            - From year 0 to 400
            - From year 295 to 315
14. Version [19.0.17](https://github.com/YahyaGamal/UK_Housing_ABM_History/blob/main/NetLogo/Housing_Market_Model_19.0.17.nlogo)
    - Increase LTV for first time buyers to 99%
        - Baseline with right-to-buy allowed
    - Allow a right-to-buy scheme (Thatcher’s policy)
        - Baseline without right-to-buy allowed
15. Version [19.0.19](https://github.com/YahyaGamal/UK_Housing_ABM_History/blob/main/NetLogo/Housing_Market_Model_19.0.19.nlogo)
    - Increase LTI from 3 to 6 for all buyers
    - Increase LTI from 3 to 6 for first-time buyers
16. Version [19.1.1](https://github.com/YahyaGamal/UK_Housing_ABM_History/blob/main/NetLogo/Housing_Market_Model_19.1.1.nlogo)
    - Update stamp duty
        - Increase stamp duty base tax for multiple properties from 3% to 5%
        - Add stamp duty tax of 2% on the portion from £125,001 to £250,000
    - Increase LTI from 4.5 to 6 for all buyers
    - Labour budget
        - (a) Update stamp duty and increase LTI for first time buyers from 4.5 to 6
        - Apply (a) and increase affordability from 18% to 33%

## Notes

- For more details on the model version 18.4.2, refer to: 
    - Gamal, Yahya, Elsenbroich, Corinna, Gilbert, Nigel, Heppenstall, Alison and Zia, Kashif (2024) 'A Behavioural Agent-Based Model for Housing Markets: Impact of Financial Shocks in the UK' Journal of Artificial Societies and Social Simulation 27 (4) 5 <http://jasss.soc.surrey.ac.uk/27/4/5.html>. doi: 10.18564/jasss.5518
- A python version of the model is available in this GitHub repository: <https://github.com/YahyaGamal/UK-housing-ABM-version-18.4.2-Public>
- A simple UI version of the model designed for teaching is available in this GitHub repository: <https://github.com/YahyaGamal/Housing_ABM_Simple_UI>
    
    
        
        
    
    
    
    
    
        

        
        
    
        
        
        

        
        
    
    