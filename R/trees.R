#' Importance variable for predictive methods
#' @param x A RandomForest or RRF object.
#' @export
var_importance <- function(x) {
  UseMethod("var_importance")
}

#' @export
var_importance.default <- function(x, ...) {
  stop("Objects of class/type ", paste(class(x), collapse = "/"),
       " are not supported by var_importance (yet).", call. = FALSE)
}

#' @export
var_importance.randomForest <- function(x) {
  randomForest::importance(x) %>%
    as.data.frame() %>%
    tibble::rownames_to_column(var = "variable") %>%
    tibble::as.tibble() %>%
    stats::setNames(c("variable", "importance")) %>%
    dplyr::arrange_("desc(importance)")
}

#' @export
var_importance.RRF <- function(x) {

  RRF::importance(x) %>%
    as.data.frame() %>%
    tibble::rownames_to_column(var = "variable") %>%
    tibble::as.tibble() %>%
    stats::setNames(c("variable", "importance")) %>%
    dplyr::arrange_("desc(importance)")

}

#' Get rules from partykit object
#' @param x A party object.
#' @examples
#'
#' library(partykit)
#' tr <- ctree(Species ~ .,data = iris)
#' ct_rules(tr)
#'
#' @export
ct_rules <- function(x) {

  lrp <- utils::getFromNamespace(".list.rules.party", "partykit")

  rules <- lrp(x)

  dout <- data.frame(
    node = as.numeric(names(rules)),
    rule = as.vector(rules)
  ) %>%
    dplyr::mutate_if(is.factor, as.character)

  dout

}
