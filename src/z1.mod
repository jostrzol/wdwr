set Products;
set StorageGroups;
set StorageGroupAssignments within {StorageGroups, Products};
set Machines;
param n_months;
set Months = {1..n_months};

param machine_count {Machines};
param unit_production_time {Machines, Products} default 0;
param average_revenue {Products};
param max_sale {Products, Months};
param storage_unit_cost_per_month;
param max_storage_in_month;
param initial_stored_products {Products};
param work_hours_in_month;

var sale {p in Products, n in Months} >= 0, <= max_sale[p,n];
var production {p in Products, n in Months} >= 0;
var storage {p in Products, n in {0} union Months} >= 0;
var storage_group_chosen {g in StorageGroups, n in Months} binary;

s.t. machine_usage_time_limit {m in Machines, n in Months}:
  sum {p in Products} production[p,n] * unit_production_time[m,p]
  <= work_hours_in_month * machine_count[m];

s.t. initial_storage {p in Products}:
  storage[p,0] = initial_stored_products[p];

s.t. one_storage_group_chosen_per_month {n in Months}:
  sum {g in StorageGroups} storage_group_chosen[g,n] <= 1;

s.t. products_stored_only_from_chosen_storage_group {n in Months, g in StorageGroups}:
  sum {(gg,p) in StorageGroupAssignments : gg = g} storage[p,n]
  <= max_storage_in_month * storage_group_chosen[g,n];

s.t. ampere_law_for_products {n in Months, p in Products}:
  production[p,n] + storage[p,n-1] = sale[p,n] + storage[p,n];

maximize profit:
  sum {p in Products, n in Months} (
    sale[p,n] * average_revenue[p] - storage[p,n] * storage_unit_cost_per_month
  );
