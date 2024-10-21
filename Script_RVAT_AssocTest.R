# Loading rvat package and creating a gdb

install.packages(rvat)
library(rvat)
gdb <- gdb("/hpc/hers_en/kdejong/KIF4A/mine_wxs_0422_KIF4A.gdb")

# making a varset list and genomatrix (GT) containing moderate variants 
varsetlist_moderate_WXS <- buildVarSet(gdb, varSetName = "moderate", unitTable = "geneVarClass", unitName = "gene_id", intersect = c("exQCpass_ALS_WXS"), where = "moderate=1")
varset_moderate_WXS <- getVarSet(varsetlist_moderate_WXS, unit = "ENSG00000090889")
GT_moderate_WXS <- getGT(gdb, varSet = varset_moderate_WXS, cohort = "ALS_WXS_tc", checkPloidy = "GRCh38")

# Performing gene-wide burden tests
Burden_moderate_WXS <- assocTest(GT_moderate_WXS, test = "firth", covar = c("sex", paste0("PC", 1:10)), pheno = "MND", maxMAF = 0.001)
Burden_moderate_WXS_0.0001 <- assocTest(GT[,GT$sex==1], test = "firth", covar = c("sex", paste0("PC", 1:10)), pheno = "MND", maxMAF = 0.0001)
Burden_moderate_WXS_singletons <- assocTest(GT[,GT$sex==2], test = "firth", covar = c("sex", paste0("PC", 1:10)), pheno = "MND", maxCarriers = 1)

# Performing male/female separated bured tests
  ## maxMAF = 0.001
Burden_WXS_male_0.001 <- assocTest(GT[,GT$sex==1], test = "firth", covar = c("sex", paste0("PC", 1:10)), pheno = "MND", maxMAF = 0.001)
Burden_WXS_female_0.001 <- assocTest(GT[,GT$sex==2], test = "firth", covar = c("sex", paste0("PC", 1:10)), pheno = "MND", maxMAF = 0.001)

  ## maxMAF = 0.0001
Burden_WXS_male_0.001 <- assocTest(GT[,GT$sex==1], test = "firth", covar = c("sex", paste0("PC", 1:10)), pheno = "MND", maxMAF = 0.0001)
Burden_WXS_female_0.001 <- assocTest(GT[,GT$sex==2], test = "firth", covar = c("sex", paste0("PC", 1:10)), pheno = "MND", maxMAF = 0.0001)

  ## singletons
Burden_WXS_female_singleton <- assocTest(test_GT[,test_GT$sex==2], test = "firth", covar = c("sex", paste0("PC", 1:10)), pheno = "MND", maxCarriers = 1)
Burden_WXS_male_singleton <- assocTest(test_GT[,test_GT$sex==1], test = "firth", covar = c("sex", paste0("PC", 1:10)), pheno = "MND", maxCarriers = 1)

# Performing Domain specific burden test
  ## selecting all moderate variants with their AM score 
am <- getAnno(gdb, table = "geneVarClass_AM_ESM1b_exQCpass_ALS_WXS") ##all variants with their AM score
am_moderate <- am[am[, "moderate"] ==1,] 

  ## add the amino acid sequence to table with the 92 variants
AlphaMissense <- getAnno(gdb, table = "AlphaMissense")
AM_moderate_2 <- am_moderate %>% left_join(AlphaMissense %>% select(VAR_id, protein_variant), by = "VAR_id") %>% distinct(VAR_id, .keep_all=TRUE) 

  ## based on the amino acid location for each mutation was determined in which domain it was located (6 variants in the motor-, 61 variants in the stalk-, and 25 variants in the tail-domain)
dom <- c(rep("motor", 6), rep("stalk", 61), rep("tail", 25)) 
AM_moderate_2$domain <- dom ##add a domain column
AM_moderate_3 <- AM_moderate_2[-c(1,28,44,52),] ## remove the samples that are not identified in AM. 

  ##creating domain-specific dataframes
AM_moderate_tail <- AM_moderate_3[AM_moderate_3[,"domain"]=="tail",]
AM_moderate_stalk <- AM_moderate_3[AM_moderate_3[,"domain"]=="stalk",]
AM_moderate_motor <- AM_moderate_3[AM_moderate_3[,"domain"]=="motor",] 

  ##creating domain specific GTs
GT_motor <- getGT(gdb, VAR_id = AM_moderate_motor$VAR_id, cohort = "ALS_WXS_tc", checkPloidy = "GRCh38") ## a GT containing the variants present in the motor domain
GT_stalk <- getGT(gdb, VAR_id = AM_moderate_stalk$VAR_id, cohort = "ALS_WXS_tc", checkPloidy = "GRCh38")
GT_tail <- getGT(gdb, VAR_id = AM_moderate_tail$VAR_id, cohort = "ALS_WXS_tc", checkPloidy = "GRCh38")

  ##performing domain specific burden tests
Burden_motor <- assocTest(GT_motor, test = "firth", covar = c("sex", paste0("PC", 1:10)), pheno = "MND", maxMAF = 0.001)
Burden_stalk <- assocTest(GT_stalk, test = "firth", covar = c("sex", paste0("PC", 1:10)), pheno = "MND", maxMAF = 0.001)
Burden_tail <- assocTest(GT_tail, test = "firth", covar = c("sex", paste0("PC", 1:10)), pheno = "MND", maxMAF = 0.001)

# Splice variant testing

