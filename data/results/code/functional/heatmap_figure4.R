library(dplyr)
library(tidyr)
library(ggplot2)
library(pheatmap)
library(openxlsx)

load(".RData")

cloud_DCM <- cloud_DCM %>%
  mutate(region = "DCM")
cloud_SRF <- cloud_SRF %>%
  mutate(region = "SRF")
cloud_MES <- cloud_MES %>%
  mutate(region = "MES")


all_terms <- bind_rows(cloud_DCM, cloud_MES, cloud_SRF)

terms_wide <- all_terms %>%
  pivot_wider(id_cols = region, names_from = desc, values_from = n) %>%
  tibble::column_to_rownames(var = "region") %>%
  as.matrix() %>%
  log() %>%
  t()

write.xlsx(data.frame(terms_wide), "../../output/functional/goterms/Figure4_matrix.xlsx", rowNames = TRUE)

terms_pheatmap <- pheatmap(
  terms_wide,
  border_color = "white",
  cluster_rows = FALSE,
  color = RColorBrewer::brewer.pal(7, "Blues"),
  angle_col = 0,
  na_col = "#fafafa"
)

terms_pheatmap

ggsave(terms_pheatmap, filename = "../../output/functional/plots/pdf/tara_terms_pheatmap.pdf", height = 8)
ggsave(terms_pheatmap, filename = "../../output/functional/plots/png/tara_terms_pheatmap.png", height = 8)
