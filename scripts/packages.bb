#!/usr/bin/env nix-shell
#!nix-shell -i bb -p babashka

(require '[babashka.cli :as cli]
         '[babashka.process :refer [shell]]
         '[clojure.string :as str])

(defn get-hostname []
  (let [env-host  (System/getenv "HOSTNAME")
        etc-host  (try (str/trim (slurp "/etc/hostname")) (catch Exception _ nil))
        java-host (try (.getHostName (java.net.InetAddress/getLocalHost)) (catch Exception _ nil))]
    (first (remove str/blank? [env-host etc-host java-host "default-system"]))))

(def cli-spec
  {:spec {:home    {:coerce :boolean :desc "Edit home-manager config instead of NixOS config"}
          :sys     {:desc "Specify system (defaults to current hostname)"} ; Removed :default from spec
          :user    {:default (System/getProperty "user.name")
                    :desc "Specify user (defaults to current user)"}
          :update  {:coerce :boolean :default true
                    :desc "Run auto-update after editing"}
          :help    {:alias :h :coerce :boolean :desc "Show this help message"}}})

(let [parsed (cli/parse-opts *command-line-args* cli-spec)
      opts   (:opts parsed)]

  (when (:help opts)
    (println "Usage: just packages [OPTIONS]")
    (println (cli/format-opts cli-spec))
    (System/exit 0))

  (let [
        sys    (let [s (:sys opts)]
                 (if (str/blank? s) (get-hostname) s))
        target (if (:home opts)
                 (str "home-manager/" sys "/packages.nix")
                 (str "nixos/" sys "/packages.nix"))]

    (println ">> Editing" target "...")
    (shell "just" "edit" target)

    (if (:update opts)
      (do
        (println ">> Applying updates...")
        (shell "just" "quick-update"))
      (println ">> Skipping update (no-update provided)."))))
