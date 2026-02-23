
#!/usr/bin/env bb

(require '[clojure.string :as str]
         '[babashka.process :refer [shell]]
         '[babashka.fs :as fs])

(def vault-name "Work_Notes")
(def walker-sep " 󰘤 ")
(def rg-sep "<rg:sep/>")

(def vault-path
  (-> (or (System/getenv "OBSIDIAN_VAULT")
          (str (fs/home) "/Documents/" vault-name))
      fs/expand-home
      fs/absolutize))

(def rg-results
  (let [output (:out (shell {:dir (str vault-path) :out :string}
                         "rg" "--no-config" "--field-match-separator" rg-sep
                         "--with-filename" "--line-number" "--no-heading" "--color=never" "-t" "md" "."))]
    (for [line (str/split-lines output)]
      (let [[file line-num content] (str/split line (re-pattern rg-sep) 3)]
        {:file file :line line-num :content content :raw (str file walker-sep content)}))))

(def selection
  (let [input (str/join "\n" (map :raw rg-results))]
    (-> (shell
          {:out :string :in input :continue true}
          "walker --dmenu --placeholder \"Search Obsidian Notes\"")
        :out
        str/trim)))

(if (str/blank? selection)
  (System/exit 0)
  (let [selected-row (first (filter #(= (:raw %) selection) rg-results))
        encoded-file (str/replace (:file selected-row) " " "%20")
        uri (str "obsidian://adv-uri?vault=" vault-name "&filepath=" encoded-file "&line=" (:line selected-row))]
    (shell "xdg-open" uri)))
